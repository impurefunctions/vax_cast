part of 'a_antigen.dart';

bool checkAntigenContraindication(
    bool contraindicated, VaxPatient patient, String targetDisease) {
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
  return contraindicated;
}
