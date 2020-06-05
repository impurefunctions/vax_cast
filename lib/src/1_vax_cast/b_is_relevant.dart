part of 'a_vax_cast.dart';

bool isRelevant(Series series, VaxPatient patient) =>
    isAppropriateGender(series.requiredGender, patient.sex)
        ? series.seriesType == 'Standard'
            ? true
            : doesIndicationApply(series.indication, patient)
        : false;

bool isAppropriateGender(String requiredGender, Gender sex) =>
//if for some reason we don't know gender, we assume appropriateness
    requiredGender == null || sex == Gender.unknown
        ? true
        : requiredGender.toLowerCase() == 'male'
            ? sex == Gender.male
            : sex != Gender.male;

bool doesIndicationApply(
    Map<String, Indication> indications, VaxPatient patient) {
  if (patient.conditions.isNotEmpty) {
    for (final condition in patient.conditions) {
      if (indications.keys.contains(condition)) {
        var indication = indications[condition];
        if (patient.dob.minIfNull(indication.beginAge) <=
                patient.assessmentDate &&
            patient.assessmentDate < patient.dob.maxIfNull(indication.endAge)) {
          return true;
        }
      }
    }
  }
  return false;
}
