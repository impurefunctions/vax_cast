import 'dart:convert';
import 'dart:io';

import 'package:fhir/fhir_r4.dart';
import 'package:vax_cast/vax_cast.dart';

void main() {
  final file = File('./lib/infrastructure/testCases/spreadsheets/healthy.csv');
  file.readAsLines().then(processLines);
}

void processLines(List<String> lines) async {
  var immunization;
  var patientBundle = Bundle(resourceType: 'Bundle', entry: []);
  var immunizationBundle = Bundle(resourceType: 'Bundle', entry: []);
  var recommendationBundle = Bundle(resourceType: 'Bundle', entry: []);

  for (var skip = 1; skip < lines.length; skip++) {
    List row = lines[skip].split(','); // split by comma
    if (row[2] != 'DOB') {
      //get the patient information
      patientBundle.entry.add(BundleEntry(
          resource: getPatient(row),
          request: BundleRequest(
              method: RequestMethod.put, url: FhirUri('Patient'))));
      //run through the doses of the vaccines given
      for (var i = 8; i < 45; i += 6) {
        //if there's no date given for the vaccine, ignore that vaccine
        if (row[i] != '') {
          immunization = getImmunization(row, i);
          immunizationBundle.entry.add(BundleEntry(
              resource: immunization,
              request: BundleRequest(
                  method: RequestMethod.put, url: FhirUri('Immunization'))));
        }
      }
      recommendationBundle.entry.add(BundleEntry(
          resource: getImmunizationRecommendation(row),
          request: BundleRequest(
              method: RequestMethod.put,
              url: FhirUri('ImmunizationRecommendation'))));
    }
  }
  await File('./lib/infrastructure/testCases/r4/HealthyCasesPatient.json')
      .writeAsString(jsonEncode(patientBundle));
  await File('./lib/infrastructure/testCases/r4/HealthyCasesImmunization.json')
      .writeAsString(jsonEncode(immunizationBundle));
  await File(
          './lib/infrastructure/testCases/r4/HealthyCasesRecommendation.json')
      .writeAsString(jsonEncode(recommendationBundle));
}

ImmunizationRecommendation getImmunizationRecommendation(List<String> row) {
  return (ImmunizationRecommendation(
    resourceType: 'ImmunizationRecommendation',
    //reference the patient
    patient: Reference(reference: 'Patient/${row[0]}'),
    //the date of the recommendation
    date: FhirDateTime(getDateTime(row[55]).toString()),
    recommendation: [
      ImmunizationRecommendationRecommendation(
          forecastStatus: CodeableConcept(text: 'Not Complete'),
          //fill in dose number of the recommendation
          doseNumberPositiveInt: row[50] != '-' && row[50] != ''
              ? PositiveInt(int.parse(row[50]))
              : null,
          dateCriterion: [
            //include the date criteria from the test cases
            ImmunizationRecommendationDateCriterion(
                code: CodeableConcept(text: 'Earliest_Date'),
                value: row[51] == '' || row[51] == null
                    ? FhirDateTime(VaxDate.max().toString())
                    : FhirDateTime(getDateTime(row[51]).toString())),
            ImmunizationRecommendationDateCriterion(
                code: CodeableConcept(text: 'Recommended_Date'),
                value: row[52] == '' || row[52] == null
                    ? FhirDateTime(VaxDate.max().toString())
                    : FhirDateTime(getDateTime(row[52]).toString())),
            ImmunizationRecommendationDateCriterion(
                code: CodeableConcept(text: 'Past_Due_Date'),
                value: row[53] == '' || row[53] == null
                    ? FhirDateTime(VaxDate.max().toString())
                    : FhirDateTime(getDateTime(row[53]).toString())),
          ],
          series: row[54],
          description: 'Evaluation_Test_Type: ${row[56]}'
              'Forecast_Test_Type: Evaluation${row[59]}'),
    ],
  ));
}

Immunization getImmunization(List<String> row, int i) {
  if (row[i] != null && row[i] != '') {
    var immunization = Immunization(
      resourceType: 'Immunization',
      patient: Reference(reference: 'Patient/${row[0]}'),
      occurrenceDateTime: FhirDateTime(getDateTime(row[i]).toString()),
      status: Code('completed'),
      vaccineCode: CodeableConcept(
        //what is the vaccine called
        text: row[i + 1],
        coding: [
          //record cvx code
          Coding(
            system: FhirUri('http://hl7.org/fhir/sid/cvx'),
            code: Code(row[i + 2]),
          ),
        ],
      ),
      reasonCode: row[i + 4] != ''
          ? [
              CodeableConcept(
                  text:
                      'Evaluation_Status_${(i - 8) / 6 + 1}: ${row[i + 4] == '' ? null : row[i + 4]}'
                      '\nEvaluation_Reason_${(i - 8) / 6 + 1}: ${row[i + 5] == '' ? null : row[i + 5]}'),
            ]
          : null,
    );
    if (row[i + 3] != null && row[i + 3] != '') {
      immunization.vaccineCode.coding.add(
        //I think this is the code system URL for MVX codes
        Coding(
          system: FhirUri('http://hl7.org/fhir/v2/0227'),
          code: Code(row[i + 3]),
        ),
      );
    }
    return immunization;
  } else {
    return null;
  }
}

DateTime getDateTime(String date) {
  if (date == '' || date == null) {
    return (null);
  } else {
    date = date.replaceAll('"', '');
    var dated = date.split('/');
    var year = int.parse(dated[2]);
    var month = int.parse(dated[0]);
    var day = int.parse(dated[1]);
    return (DateTime(year, month, day));
  }
}

Patient getPatient(List<String> row) {
  var patient = Patient(
    resourceType: 'Patient',
    id: Id(row[0]),
    birthDate: Date(getDateTime(row[2]).toString()),
    gender: row[3] == 'M' ? Gender.male : Gender.female,
    //family name is the brief description of the case
    name: [
      HumanName(
        family: row[1],
        given: row[7] != null && row[7] != ''
            ? ['Series_Status: ${row[7]}']
            : null,
        text: row[62] != null && row[62] != '' ? row[62] : null,
      ),
    ],
  );

  //these are the columns that state the dose evaluation status and reason, if available
  for (final eval in [12, 18, 24, 30, 36, 42, 48]) {
    if (row[eval] != '') {
      {
        row[eval] != null && row[eval] != ''
            ? patient.name[0].given
                .add('Evaluation_Status_${eval / 6 - 1}: ${row[eval]}')
            : null;
        row[eval + 1] != null && row[eval + 1] != ''
            ? patient.name[0].given
                .add('Evaluation_Reason_${eval / 6 - 1}: ${row[eval + 1]}')
            : null;
      }
    }
  }
  return patient;
}
