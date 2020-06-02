import 'package:fhir/fhir_r4.dart' as fhir_r4;
import 'package:fhir/fhir_stu3.dart' as fhir_stu3;
import 'package:fhir/fhir_dstu2.dart' as fhir_dstu2;

import '../../shared.dart';

part 'vax_patient_from_R4.dart';
part 'vax_patient_from_Stu3.dart';
part 'vax_patient_from_Dstu2.dart';

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

  factory VaxPatient.fromFhir(Version version, bool bundles, patient,
      immunizations, recommendations, conditions) {
    switch (version) {
      case Version.r4:
        return bundles
            ? _$VaxPatientFromR4Bundles(
                patient, immunizations, recommendations, conditions)
            : _$VaxPatientFromR4(
                patient, immunizations, recommendations, conditions);
      case Version.stu3:
        return bundles
            ? _$VaxPatientFromStu3Bundles(
                patient, immunizations, recommendations, conditions)
            : _$VaxPatientFromStu3(
                patient, immunizations, recommendations, conditions);
      case Version.dstu2:
        return bundles
            ? _$VaxPatientFromDstu2Bundles(
                patient, immunizations, recommendations, conditions)
            : _$VaxPatientFromDstu2(
                patient, immunizations, recommendations, conditions);
    }
    return null;
  }

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
