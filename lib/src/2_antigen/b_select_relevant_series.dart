part of 'a_antigen.dart';

List<VaxSeries> relevantSeries(VaxPatient patient, Dz dz) {
  List<VaxSeries> series = <VaxSeries>[];
  for (final newSeries
      in SupportingData.antigenSupportingData[dz.toString()].series) {
    if (isRelevant(newSeries, patient)) {
      series.add(VaxSeries(newSeries));
    }
  }
  return series;
}

bool isRelevant(Series series, VaxPatient patient) =>
    isAppropriateGender(series.requiredGender, patient.gender)
        ? series.seriesType == 'Standard'
            ? true
            : doesIndicationApply(series.indication, patient)
        : false;

bool isAppropriateGender(String requiredGender, VaxGender gender) =>
    //if we don't know, we assume it's appropriate
    requiredGender == null || gender == null
        ? true
        : requiredGender.toLowerCase() == 'male'
            ? gender == VaxGender.male
            : gender != VaxGender.male;

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
