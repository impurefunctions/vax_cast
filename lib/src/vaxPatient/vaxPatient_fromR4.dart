part of 'vaxPatient.dart';

VaxPatient _$VaxPatientFromR4(
    fhir_r4.Patient patient,
    List<fhir_r4.Immunization> immunizations,
    List<fhir_r4.ImmunizationRecommendation> recommendations,
    List<fhir_r4.Condition> conditions) {
  var newPatient = VaxPatient(
    dob: VaxDate.fromString(patient.birthDate.toString()),
    sex: patient.gender.toString() == 'female' ? 'Female' : 'Male',
    liveVirusList: <Dose>[],
    pastImmunizations: <Dose>[],
    conditions: <String>[],
    assessmentDate: VaxDate.fromString(recommendations[0].date.toString()),
    recommendations: recommendations,
    seriesGroup: recommendations[0].recommendation[0].series,
  );
  immunizations.forEach((vax) => newPatient.addToVaxListR4(vax));
  conditions.forEach((condition) => newPatient.addToConditionListR4(condition));
  return newPatient;
}

VaxPatient _$VaxPatientFromR4Bundles(
    fhir_r4.Bundle patientBundle,
    fhir_r4.Bundle immunizationBundle,
    fhir_r4.Bundle recommendationBundle,
    fhir_r4.Bundle conditionBundle) {
  var newPatient = VaxPatient(
    dob: VaxDate.fromString(
        patientBundle.entry[0].resource.birthDate.toString()),
    sex: patientBundle.entry[0].resource.gender.toString() == 'other'
        ? 'Unknown'
        : patientBundle.entry[0].resource.gender.toString()[0].toUpperCase() +
            patientBundle.entry[0].resource.gender.toString().substring(
                1, patientBundle.entry[0].resource.gender.toString().length),
    liveVirusList: <Dose>[],
    pastImmunizations: <Dose>[],
    conditions: <String>[],
    assessmentDate: VaxDate.fromString(
        recommendationBundle.entry[0].resource.date.toString()),
    recommendations: <fhir_r4.ImmunizationRecommendation>[],
    seriesGroup:
        recommendationBundle.entry[0].resource.recommendation[0].series,
  );
  immunizationBundle.entry
      .forEach((entry) => newPatient.addToVaxListR4(entry.resource));
  conditionBundle.entry
      .forEach((entry) => newPatient.addToConditionListR4(entry.resource));
  recommendationBundle.entry
      .forEach((entry) => newPatient.recommendations.add(entry.resource));
  return newPatient;
}
