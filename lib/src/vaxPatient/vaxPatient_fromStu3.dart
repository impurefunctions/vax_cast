part of 'vaxPatient.dart';

VaxPatient _$VaxPatientFromStu3(
  fhir_stu3.Patient patient,
  List<fhir_stu3.Immunization> immunizations,
  List<fhir_stu3.ImmunizationRecommendation> recommendations,
  List<fhir_stu3.Condition> conditions,
) {
  var newPatient = VaxPatient(
    dob: VaxDate.fromString(patient.birthDate.toString()),
    sex: patient.gender.toString() == 'female' ? 'Female' : 'Male',
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
    assessmentDate: VaxDate.fromString(recommendationBundle
        .entry[0].resource.recommendation[0].date
        .toString()),
    recommendations: VaxRecommendations(
        earliestDate: VaxDate.fromString(
          recommendationBundle
              .entry[0].resource.recommendation[0].dateCriterion[0].value
              .toString(),
        ),
        recommendedDate: VaxDate.fromString(
          recommendationBundle
              .entry[0].resource.recommendation[0].dateCriterion[1].value
              .toString(),
        ),
        pastDueDate: VaxDate.fromString(
          recommendationBundle
              .entry[0].resource.recommendation[0].dateCriterion[2].value
              .toString(),
        )),
    seriesGroup:
        recommendationBundle.entry[0].resource.recommendation[0].series,
  );
  immunizationBundle.entry
      .forEach((entry) => newPatient.addToVaxListStu3(entry.resource));
  conditionBundle.entry
      .forEach((entry) => newPatient.addToConditionListStu3(entry.resource));
  return newPatient;
}
