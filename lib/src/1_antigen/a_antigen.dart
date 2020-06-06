import 'package:vax_cast/src/9_shared/shared.dart';

class Antigen {
  String seriesVaccineGroup;
  List<Group> groups;
  bool immunity;
  bool contraindicated;
  VaxPatient patient;
  String targetDisease;

  Antigen(
    this.patient,
    this.targetDisease,
  );

  void newSeries(Series series) {
    if (series?.seriesDose != null) {
      if (groups == null) {
        groups = <Group>[Group(series, patient)];
        seriesVaccineGroup = series.seriesVaccineGroup;
      } else {
        var group = groups.firstWhere(
            (group) => group.seriesGroup == series.seriesGroup,
            orElse: () => null);
        group == null
            ? groups.add(Group(series, patient))
            : group.vaxSeries.add(VaxSeries(series, patient));
      }
    }
  }

  bool isSingleAgVaxGroup() =>
      seriesVaccineGroup != 'MMR' && seriesVaccineGroup != 'DTAP';

  void getForecast() {
    groups.forEach((group) {
      group.evaluateAllPatientSeries();
      checkForImmunity();
      checkAntigenContraindication();
      group.forecastEachSeries(immunity, contraindicated);
    });
    groups.removeWhere((group) => group.vaxSeries.isEmpty);
    groups.forEach((group) => group.selectPatientSeries());
    groups.retainWhere((group) => group.prioritizedSeries != -1);
    groups.forEach((group) => group.isItABestSeries(groups));
    groups.retainWhere((group) => group.bestGroup);
  }

  void checkForImmunity() {
    if (immunity ?? true) {
      immunity = false;
      if (patient.conditions != null) {
        var immuneConditions =
            SupportingData.antigenSupportingData[targetDisease].immunity;
        if (immuneConditions != null) {
          immuneConditions.clinicalHistory.forEach((condition) =>
              immunity |= patient.conditions.contains(condition.guidelineCode));
          if (!immunity && immuneConditions.dateOfBirth != null) {
            if (patient.dob <
                VaxDate.mmddyyyy(
                    immuneConditions.dateOfBirth.immunityBirthDate)) {
              var exclusionCondition = false;
              immuneConditions.dateOfBirth.exclusion.forEach((exclusion) =>
                  exclusionCondition |=
                      patient.conditions.contains(exclusion.exclusionCode));
              immunity = !exclusionCondition;
            }
          }
        }
      }
    }
  }

  void checkAntigenContraindication() {
    if (contraindicated ?? true) {
      contraindicated = false;
      if (patient.conditions != null) {
        for (final condition in patient.conditions) {
          var obsCondition = SupportingData.antigenSupportingData[targetDisease]
              .contraindications.group[condition];
          if (obsCondition != null) {
            contraindicated |= patient.assessmentDate <
                    patient.dob.maxIfNull(obsCondition.endAge) &&
                patient.dob.minIfNull(obsCondition.beginAge) <=
                    patient.assessmentDate;
          }
        }
      }
    }
  }
}
