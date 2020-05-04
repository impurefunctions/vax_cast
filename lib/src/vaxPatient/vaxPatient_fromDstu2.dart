part of 'vaxPatient.dart';

VaxPatient _$VaxPatientFromDstu2(
  fhir_dstu2.Patient patient,
  List<fhir_dstu2.Immunization> immunizations,
  List<fhir_dstu2.ImmunizationRecommendation> recommendations,
  List<fhir_dstu2.Condition> conditions,
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
      .forEach((entry) => newPatient.addToVaxListDstu2(entry.resource));
  conditionBundle.entry
      .forEach((entry) => newPatient.addToConditionListDstu2(entry.resource));
  return newPatient;
}
