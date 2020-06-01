import 'package:fhir/fhir_r4.dart' as fhir_r4;
import 'package:fhir/fhir_stu3.dart' as fhir_stu3;
import 'package:fhir/fhir_dstu2.dart' as fhir_dstu2;

import 'antigen.dart';
import 'dose.dart';
import 'groupForecast.dart';
import 'supportingData/antigenSupportingData/classes/indication.dart';
import 'supportingData/antigenSupportingData/classes/series.dart';
import 'supportingData/supportingData.dart';
import 'vaxPatient/vaxPatient.dart';

class Forecast {
  Map<String, Antigen> antigens;
  List<GroupForecast> groupForecast;
  VaxPatient patient;

  Forecast({
    this.antigens,
    this.groupForecast,
    this.patient,
  }) {
    this.antigens = <String, Antigen>{};
  }

  void readSupportingData() async => await SupportingData.load();

  Future<List<GroupForecast>> r4Forecast(
      fhir_r4.Patient patient,
      List<fhir_r4.Immunization> immunizations,
      List<fhir_r4.ImmunizationRecommendation> recommendations,
      List<fhir_r4.Condition> conditions) async {
    await readSupportingData();
    this.patient = VaxPatient.fromR4(
      patient,
      immunizations,
      recommendations,
      conditions,
    );
    loadHx();
    getForecast();
    return groupForecast;
  }

  Future<List<GroupForecast>> createR4Forecast(
    fhir_r4.Bundle patientBundle,
    fhir_r4.Bundle immunizationBundle,
    fhir_r4.Bundle recommendationBundle,
    fhir_r4.Bundle conditionBundle,
  ) async {
    await readSupportingData();
    patient = VaxPatient.fromR4Bundles(
      patientBundle,
      immunizationBundle,
      recommendationBundle,
      conditionBundle,
    );
    loadHx();
    getForecast();
    return groupForecast;
  }

  Future<List<GroupForecast>> createStu3Forecast(
    fhir_stu3.Bundle patientBundle,
    fhir_stu3.Bundle immunizationBundle,
    fhir_stu3.Bundle recommendationBundle,
    fhir_stu3.Bundle conditionBundle,
  ) async {
    await readSupportingData();
    patient = VaxPatient.fromStu3Bundles(
      patientBundle,
      immunizationBundle,
      recommendationBundle,
      conditionBundle,
    );
    loadHx();
    getForecast();
    return groupForecast;
  }

  Future<List<GroupForecast>> createDstu2Forecast(
    fhir_dstu2.Bundle patientBundle,
    fhir_dstu2.Bundle immunizationBundle,
    fhir_dstu2.Bundle recommendationBundle,
    fhir_dstu2.Bundle conditionBundle,
  ) async {
    await readSupportingData();
    patient = VaxPatient.fromDstu2Bundles(
      patientBundle,
      immunizationBundle,
      recommendationBundle,
      conditionBundle,
    );
    loadHx();
    getForecast();
    return groupForecast;
  }

  void loadHx() {
    loadSupportingData();
    antigens.removeWhere((ag, antigen) => antigen.groups == null);
  }

  void loadSupportingData() {
    SupportingData.antigenSupportingData.forEach((ag, seriesGroup) {
      antigens[ag] = Antigen(patient: patient, targetDisease: ag);
      for (var series in seriesGroup.series) {
        if (isRelevant(series)) antigens[ag].newSeries(series);
      }
      loadScheduleSupportingData(ag);
    });
  }

  bool isRelevant(Series series) => isAppropriateGender(series.requiredGender)
      ? series.seriesType == 'Standard'
          ? true
          : doesIndicationApply(series.indication)
      : false;

  bool isAppropriateGender(String requiredGender) =>
      //if for some reason we don't know the patient's gender,
      //we assume it's appropriate
      requiredGender == null
          ? true
          : patient.sex == null
              ? requiredGender.toLowerCase() == 'male'
              : !(requiredGender.toLowerCase() == 'male' &&
                      patient.sex.toLowerCase() == 'female' ||
                  requiredGender.toLowerCase() == 'female' &&
                      patient.sex.toLowerCase() == 'male' ||
                  requiredGender.toLowerCase() == 'unknown' &&
                      patient.sex.toLowerCase() == 'male');

  bool doesIndicationApply(Map<String, Indication> indications) {
    if (patient.conditions.isNotEmpty) {
      for (final condition in patient.conditions) {
        if (indications.keys.contains(condition)) {
          var indication = indications[condition];
          if (patient.dob.minIfNull(indication.beginAge) <=
                  patient.assessmentDate &&
              patient.assessmentDate <
                  patient.dob.maxIfNull(indication.endAge)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void loadScheduleSupportingData(String ag) {
    for (final dose in patient.pastImmunizations) {
      if (SupportingData.isAgInCvx(dose.cvx, ag)) {
        for (final group in antigens[ag].groups) {
          for (final series in group.vaxSeries) {
            series.pastDoses.add(Dose.copy(dose));
          }
        }
      }
    }
  }

  void getForecast() {
//remove after testing ******************************************************//
    antigens.removeWhere(
        (ag, antigen) => antigen.seriesVaccineGroup != patient.seriesGroup);
// ***************************************************************************//
    antigens.forEach((ag, antigen) => antigen.getForecast());
    groupForecast = <GroupForecast>[];
    antigens.forEach((ag, antigen) => identifyAndEvaluateVaccineGroup(antigen));
    groupForecast.forEach((forecast) => forecast.convertNull());
  }

  void identifyAndEvaluateVaccineGroup(Antigen antigen) {
    antigen.groups.forEach((seriesGroup) {
      if (antigen.isSingleAgVaxGroup()) {
        groupForecast.add(GroupForecast.singleAg(seriesGroup.vaxSeries[0]));
      } else {
        var alreadyIncluded = false;
        for (final forecast in groupForecast) {
          alreadyIncluded = alreadyIncluded ||
              forecast.seriesVaccineGroup == antigen.seriesVaccineGroup;
        }
        if (!alreadyIncluded) {
          var newGroupForecast = GroupForecast();
          var incomplete = false;
          var immune = true;
          var contraindication = false;
          for (final ag in antigens.keys) {
            if (antigens[ag].seriesVaccineGroup == antigen.seriesVaccineGroup) {
              for (final series in antigens[ag].groups) {
                var curSeries = series.vaxSeries[0];
                incomplete =
                    incomplete || curSeries.seriesStatus == 'not complete';
                immune = immune && curSeries.seriesStatus == 'immune';
                contraindication = contraindication ||
                    curSeries.seriesStatus == 'contraindicated';
                newGroupForecast.applyMultiAgLogic(curSeries);
              }
            }
          }
          newGroupForecast.finalDates();
          if (immune) {
            newGroupForecast.groupStatus = 'immune';
          } else if (contraindication) {
            newGroupForecast.groupStatus = 'contraindicated';
          } else if (incomplete) {
            newGroupForecast.groupStatus = 'not complete';
          } else {
            newGroupForecast.groupStatus = 'complete';
          }
          newGroupForecast.seriesVaccineGroup = antigen.seriesVaccineGroup;
          groupForecast.add(newGroupForecast);
        }
      }
    });
  }
}
