part of 'vax_patient.dart';

VaxPatient _$VaxPatientFromDstu2(
  fhir_dstu2.Patient patient,
  List<fhir_dstu2.Immunization> immunizations,
  List<fhir_dstu2.ImmunizationRecommendation> recommendations,
  List<fhir_dstu2.Condition> conditions,
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
    assessmentDate: VaxDate.fromString(
        recommendations[0].recommendation[0].date.toString()),
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
    seriesGroup: recommendations[0].recommendation[0].protocol.series,
  );
  immunizations.forEach((vax) => newPatient.addToVaxListDstu2(vax));
  conditions
      .forEach((condition) => newPatient.addToConditionListDstu2(condition));
  return newPatient;
}

VaxPatient _$VaxPatientFromDstu2Bundles(
  fhir_dstu2.Bundle patientBundle,
  fhir_dstu2.Bundle immunizationBundle,
  fhir_dstu2.Bundle recommendationBundle,
  fhir_dstu2.Bundle conditionBundle,
) {
  var patient =
      fhir_dstu2.Patient.fromJson(patientBundle.entry[0].resource.toJson());
  var recommendation = fhir_dstu2.ImmunizationRecommendation.fromJson(
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
    assessmentDate:
        VaxDate.fromString(recommendation.recommendation[0].date.toString()),
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
    seriesGroup: recommendation.recommendation[0].protocol.series,
  );
  immunizationBundle.entry
      .forEach((entry) => newPatient.addToVaxListDstu2(entry.resource));
  conditionBundle.entry
      .forEach((entry) => newPatient.addToConditionListDstu2(entry.resource));
  return newPatient;
}
