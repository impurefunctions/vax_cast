import 'package:fhir_r4/fhir_r4.dart' as fhir_r4;
import 'package:fhir_stu3/fhir_stu3.dart' as fhir_stu3;
import 'package:fhir_dstu2/fhir_dstu2.dart' as fhir_dstu2;

import '../supportingData/supportingData.dart';
import '../dose.dart';
import '../vaxDate.dart';

part 'vaxPatient_fromR4.dart';
part 'vaxPatient_fromStu3.dart';
part 'vaxPatient_fromDstu2.dart';

class VaxPatient {
  VaxDate dob;
  String sex;
  List<String> conditions;
  VaxDate assessmentDate;
  List<Dose> liveVirusList;
  List<Dose> pastImmunizations;
  VaxRecommendations recommendations;
  String seriesGroup;

  VaxPatient({
    this.dob,
    this.sex,
    this.conditions,
    this.assessmentDate,
    this.liveVirusList,
    this.pastImmunizations,
    this.recommendations,
    this.seriesGroup,
  });

  factory VaxPatient.fromR4(
          fhir_r4.Patient patient,
          List<fhir_r4.Immunization> immunizations,
          List<fhir_r4.ImmunizationRecommendation> recommendations,
          List<fhir_r4.Condition> conditions) =>
      _$VaxPatientFromR4(patient, immunizations, recommendations, conditions);

  factory VaxPatient.fromR4Bundles(
          fhir_r4.Bundle patientBundle,
          fhir_r4.Bundle immunizationBundle,
          fhir_r4.Bundle recommendationBundle,
          fhir_r4.Bundle conditionBundle) =>
      _$VaxPatientFromR4Bundles(patientBundle, immunizationBundle,
          recommendationBundle, conditionBundle);

  factory VaxPatient.fromStu3(
          fhir_stu3.Patient patient,
          List<fhir_stu3.Immunization> immunizations,
          List<fhir_stu3.ImmunizationRecommendation> recommendations,
          List<fhir_stu3.Condition> conditions) =>
      _$VaxPatientFromStu3(patient, immunizations, recommendations, conditions);

  factory VaxPatient.fromStu3Bundles(
    fhir_stu3.Bundle patientBundle,
    fhir_stu3.Bundle immunizationBundle,
    fhir_stu3.Bundle recommendationBundle,
    fhir_stu3.Bundle conditionBundle,
  ) =>
      _$VaxPatientFromStu3Bundles(patientBundle, immunizationBundle,
          recommendationBundle, conditionBundle);

  factory VaxPatient.fromDstu2(
          fhir_dstu2.Patient patient,
          List<fhir_dstu2.Immunization> immunizations,
          List<fhir_dstu2.ImmunizationRecommendation> recommendations,
          List<fhir_dstu2.Condition> conditions) =>
      _$VaxPatientFromDstu2(
          patient, immunizations, recommendations, conditions);

  factory VaxPatient.fromDstu2Bundles(
    fhir_dstu2.Bundle patientBundle,
    fhir_dstu2.Bundle immunizationBundle,
    fhir_dstu2.Bundle recommendationBundle,
    fhir_dstu2.Bundle conditionBundle,
  ) =>
      _$VaxPatientFromDstu2Bundles(patientBundle, immunizationBundle,
          recommendationBundle, conditionBundle);

  void addToVaxListR4(fhir_r4.Immunization vax) {
    var newDose = Dose(
      dateGiven: VaxDate.fromString(vax.occurrenceDateTime.toString()),
      cvx: vax.vaccineCode.coding[0].code.toString().length == 1
          ? '0' + vax.vaccineCode.coding[0].code.toString()
          : vax.vaccineCode.coding[0].code.toString(),
      mvx: vax.vaccineCode.coding.length > 1
          ? vax.vaccineCode.coding[1].code.toString()
          : null,
    );
    pastImmunizations.add(newDose);
    var index = SupportingData.scheduleSupportingData.liveVirusConflicts
        .indexWhere((liveCvx) => liveCvx.previousCvx == newDose.cvx);
    if (index != -1) {
      liveVirusList.add(newDose);
    }
  }

  void addToConditionListR4(fhir_r4.Condition condition) {
    var condIndex = condition.code.coding
        .indexWhere((coding) => coding.system.toString().contains('snomed'));
    if (condIndex != -1) {
      SupportingData.scheduleSupportingData.observations.forEach((code, info) {
        if (info.codedValues != null) {
          for (final codedValue in info.codedValues) {
            if (condition.code.coding[condIndex].system.toString() ==
                codedValue.code.toString()) {
              conditions.add(code);
            }
          }
        }
      });
    }
  }

  void addToVaxListStu3(fhir_stu3.Immunization vax) {
    var newDose = Dose(
      dateGiven: VaxDate.fromString(vax.date.toString()),
      cvx: vax.vaccineCode.coding[0].code.toString().length == 1
          ? '0' + vax.vaccineCode.coding[0].code.toString()
          : vax.vaccineCode.coding[0].code.toString(),
      mvx: vax.vaccineCode.coding.length > 1
          ? vax.vaccineCode.coding[1].code.toString()
          : null,
    );
    pastImmunizations.add(newDose);
    var index = SupportingData.scheduleSupportingData.liveVirusConflicts
        .indexWhere((liveCvx) => liveCvx.previousCvx == newDose.cvx);
    if (index != -1) {
      liveVirusList.add(newDose);
    }
  }

  void addToConditionListStu3(fhir_stu3.Condition condition) {
    var condIndex = condition.code.coding
        .indexWhere((coding) => coding.system.toString().contains('snomed'));
    if (condIndex != -1) {
      SupportingData.scheduleSupportingData.observations.forEach((code, info) {
        if (info.codedValues != null) {
          for (final codedValue in info.codedValues) {
            if (condition.code.coding[condIndex].system.toString() ==
                codedValue.code.toString()) {
              conditions.add(code);
            }
          }
        }
      });
    }
  }

  void addToVaxListDstu2(fhir_dstu2.Immunization vax) {
    var newDose = Dose(
      dateGiven: VaxDate.fromString(vax.date.toString()),
      cvx: vax.vaccineCode.coding[0].code.toString().length == 1
          ? '0' + vax.vaccineCode.coding[0].code.toString()
          : vax.vaccineCode.coding[0].code.toString(),
      mvx: vax.vaccineCode.coding.length > 1
          ? vax.vaccineCode.coding[1].code.toString()
          : null,
    );
    pastImmunizations.add(newDose);
    var index = SupportingData.scheduleSupportingData.liveVirusConflicts
        .indexWhere((liveCvx) => liveCvx.previousCvx == newDose.cvx);
    if (index != -1) {
      liveVirusList.add(newDose);
    }
  }

  void addToConditionListDstu2(fhir_dstu2.Condition condition) {
    var condIndex = condition.code.coding
        .indexWhere((coding) => coding.system.toString().contains('snomed'));
    if (condIndex != -1) {
      SupportingData.scheduleSupportingData.observations.forEach((code, info) {
        if (info.codedValues != null) {
          for (final codedValue in info.codedValues) {
            if (condition.code.coding[condIndex].system.toString() ==
                codedValue.code.toString()) {
              conditions.add(code);
            }
          }
        }
      });
    }
  }
}

class VaxRecommendations {
  VaxDate earliestDate;
  VaxDate recommendedDate;
  VaxDate pastDueDate;

  VaxRecommendations({
    this.earliestDate,
    this.recommendedDate,
    this.pastDueDate,
  });
}
