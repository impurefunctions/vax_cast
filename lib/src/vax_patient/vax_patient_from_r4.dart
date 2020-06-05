part of 'vax_patient.dart';

VaxPatient _$VaxPatientFromR4(
  fhir_r4.Patient patient,
  List<fhir_r4.Immunization> immunizations,
  List<fhir_r4.ImmunizationRecommendation> recommendations,
  List<fhir_r4.Condition> conditions,
) {
  var newPatient = VaxPatient(
    dob: VaxDate.fromString(patient.birthDate.toString()),
    sex: patient?.gender?.toString()?.toLowerCase() == 'female'
        ? Gender.female
        : patient?.gender?.toString()?.toLowerCase() == 'male'
            ? Gender.male
            : Gender.unknown,
    liveVirusList: <Dose>[],
    pastImmunizations: <Dose>[],
    conditions: <String>[],
    assessmentDate: VaxDate.fromString(recommendations[0].date.toString()),
    recommendations: VaxRecommendations(
        earliestDate: VaxDate.fromString(recommendations[0]
            .recommendation[0]
            .dateCriterion[0]
            .value
            .toString()),
        recommendedDate: VaxDate.fromString(recommendations[0]
            .recommendation[0]
            .dateCriterion[1]
            .value
            .toString()),
        pastDueDate: VaxDate.fromString(
          recommendations[0]
              .recommendation[0]
              .dateCriterion[2]
              .value
              .toString(),
        )),
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
  fhir_r4.Bundle conditionBundle,
) {
  var patient =
      fhir_r4.Patient.fromJson(patientBundle.entry[0].resource.toJson());
  var recommendation = fhir_r4.ImmunizationRecommendation.fromJson(
      recommendationBundle.entry[0].resource.toJson());
  var newPatient = VaxPatient(
    dob: VaxDate.fromString(patient.birthDate.toString()),
    sex: patient?.gender?.toString()?.toLowerCase() == 'female'
        ? Gender.female
        : patient?.gender?.toString()?.toLowerCase() == 'male'
            ? Gender.male
            : Gender.unknown,
    liveVirusList: <Dose>[],
    pastImmunizations: <Dose>[],
    conditions: <String>[],
    assessmentDate: VaxDate.fromString(recommendation.date.toString()),
    recommendations: VaxRecommendations(
        earliestDate: VaxDate.fromString(
          recommendation.recommendation[0].dateCriterion[0].value.toString(),
        ),
        recommendedDate: VaxDate.fromString(
          recommendation.recommendation[0].dateCriterion[1].value.toString(),
        ),
        pastDueDate: VaxDate.fromString(
          recommendation.recommendation[0].dateCriterion[2].value.toString(),
        )),
    seriesGroup: recommendation.recommendation[0].series,
  );
  immunizationBundle.entry.forEach((entry) => newPatient
      .addToVaxListR4(fhir_r4.Immunization.fromJson(entry.resource.toJson())));
  conditionBundle.entry.forEach((entry) => newPatient.addToConditionListR4(
      fhir_r4.Condition.fromJson(entry.resource.toJson())));
  return newPatient;
}
