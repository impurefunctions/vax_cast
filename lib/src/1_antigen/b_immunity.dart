part of 'a_antigen.dart';

bool checkForImmunity(bool immunity, VaxPatient patient, String targetDisease) {
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
  return immunity;
}
