part of 'vax_patient.dart';

VaxPatient _$VaxPatientFromStu3(
  fhir_stu3.Patient patient,
  List<fhir_stu3.Immunization> immunizations,
  List<fhir_stu3.ImmunizationRecommendation> recommendations,
  List<fhir_stu3.Condition> conditions,
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
  immunizations.forEach((vax) => newPatient.addToVaxListStu3(vax));
  conditions
      .forEach((condition) => newPatient.addToConditionListStu3(condition));
  return newPatient;
}

VaxPatient _$VaxPatientFromStu3Bundles(
  fhir_stu3.Bundle patientBundle,
  fhir_stu3.Bundle immunizationBundle,
  fhir_stu3.Bundle recommendationBundle,
  fhir_stu3.Bundle conditionBundle,
) {
  var patient =
      fhir_stu3.Patient.fromJson(patientBundle.entry[0].resource.toJson());
  var recommendation = fhir_stu3.ImmunizationRecommendation.fromJson(
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
      .forEach((entry) => newPatient.addToVaxListStu3(entry.resource));
  conditionBundle.entry
      .forEach((entry) => newPatient.addToConditionListStu3(entry.resource));
  return newPatient;
}
