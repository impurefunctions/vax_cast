// import 'dart:convert';
// import 'dart:io';

// import 'package:intl/intl.dart';

// void main() {
//   final file = File('./bin/immunization/testCases/healthyTestCases.csv');
//   file.readAsLines().then(processLines);
// }

// void processLines(List<String> lines) async {
//   var immunization;
//   var bundle = Bundle(resourceType: 'Bundle', entry: []);

//   for (var skip = 1; skip < lines.length; skip++) {
//     List row = lines[skip].split(','); // split by comma
//     if (row[2] != 'DOB') {
//       //get the patient information
//       bundle.entry.add(Bundle_Entry(
//           resource: getPatient(row),
//           request: Bundle_Request(method: 'PUT', url: 'Patient')));
//       //run through the doses of the vaccines given
//       for (var i = 8; i < 45; i += 6) {
//         //if there's no date given for the vaccine, ignore that vaccine
//         if (row[i] != '') {
//           immunization = getImmunization(row, i);
//           bundle.entry.add(Bundle_Entry(
//               resource: immunization,
//               request: Bundle_Request(method: 'PUT', url: 'Immunization')));
//         }
//       }
//       bundle.entry.add(Bundle_Entry(
//           resource: getImmunizationRecommendation(row),
//           request: Bundle_Request(
//               method: 'PUT', url: 'ImmunizationRecommendation')));
//     }
//   }
//   await File('./bin/stu3/stu3TestCases/stu3HealthyCases.json')
//       .writeAsString(jsonEncode(bundle));
// }

// ImmunizationRecommendation getImmunizationRecommendation(List<String> row) {
//   return (ImmunizationRecommendation(
//     resourceType: 'ImmunizationRecommendation',
//     //reference the patient
//     patient: Reference(reference: 'Patient/${row[0]}'),
//     recommendation: [
//       ImmunizationRecommendation_Recommendation(
//         //the date of the recommendation
//         date: DateFormat('yyyy-MM-dd').format(getDateTime(row[55])),
//         forecastStatus: CodeableConcept(text: 'Not Complete'),
//         //fill in dose number of the recommendation
//         doseNumber: row[50] != '-' && row[50] != '' ? int.parse(row[50]) : null,
//         dateCriterion: [
//           //include the date criteria from the test cases
//           ImmunizationRecommendation_DateCriterion(
//               code: CodeableConcept(text: 'Earliest_Date'),
//               value: row[51] == '' || row[51] == null
//                   ? null
//                   : DateFormat('yyyy-MM-dd').format(getDateTime(row[51]))),
//           ImmunizationRecommendation_DateCriterion(
//               code: CodeableConcept(text: 'Recommended_Date'),
//               value: row[52] == '' || row[52] == null
//                   ? null
//                   : DateFormat('yyyy-MM-dd').format(getDateTime(row[52]))),
//           ImmunizationRecommendation_DateCriterion(
//               code: CodeableConcept(text: 'Past_Due_Date'),
//               value: row[53] == '' || row[53] == null
//                   ? null
//                   : DateFormat('yyyy-MM-dd').format(getDateTime(row[53]))),
//         ],
//         protocol: ImmunizationRecommendation_Protocol(
//             series: row[54],
//             description: 'Evaluation_Test_Type: ${row[56]}'
//                 'Forecast_Test_Type: Evaluation${row[59]}'),
//       )
//     ],
//   ));
// }

// Immunization getImmunization(List<String> row, int i) {
//   if (row[i] != null && row[i] != '') {
//     var immunization = Immunization(
//         resourceType: 'Immunization',
//         patient: Reference(reference: 'Patient/${row[0]}'),
//         date: DateFormat('yyyy-MM-dd').format(getDateTime(row[i])),
//         status: 'completed',
//         vaccineCode: CodeableConcept(
//             //what is the vaccine called
//             text: row[i + 1],
//             coding: [
//               //record cvx code
//               Coding(
//                 system: 'http://hl7.org/fhir/sid/cvx',
//                 code: row[i + 2],
//               )
//             ]));
//     if (row[i + 3] != null && row[i + 3] != '') {
//       immunization.vaccineCode.coding.add(
//           //I think this is the code system URL for MVX codes
//           Coding(
//         system: 'http://hl7.org/fhir/v2/0227',
//         code: row[i + 3],
//       ));
//     }
//     if (row[i + 4] != '') {
//       immunization.vaccinationProtocol = [
//         Immunization_VaccinationProtocol(
//           targetDisease: [CodeableConcept(text: getDz(row[i + 2]))],
//           doseStatus: CodeableConcept(
//               text:
//                   'Evaluation_Status_${(i - 8) / 6 + 1}: ${row[i + 4] == '' ? null : row[i + 4]}'),
//           doseStatusReason: CodeableConcept(
//               text:
//                   'Evaluation_Reason_${(i - 8) / 6 + 1}: ${row[i + 5] == '' ? null : row[i + 5]}'),
//         )
//       ];
//     }
//     return immunization;
//   } else {
//     return null;
//   }
// }

// DateTime getDateTime(String date) {
//   if (date == '' || date == null) {
//     return (null);
//   } else {
//     var dated = date.split('/');
//     var year = int.parse(dated[2]);
//     var month = int.parse(dated[0]);
//     var day = int.parse(dated[1]);
//     return (DateTime(year, month, day));
//   }
// }

// Patient getPatient(List<String> row) {
//   var patient = Patient(
//     resourceType: 'Patient',
//     id: row[0],
//     birthDate: getDateTime(row[2]),
//     gender: row[3] == 'M' ? 'male' : 'female',
//     //family name is the brief description of the case
//     name: [HumanName(family: row[1], given: [])],
//   );
//   //add the series status to given names
//   row[7] != null && row[7] != ''
//       ? patient.name[0].given.add('Series_Status: ${row[7]}')
//       : null;
//   row[62] != null && row[62] != '' ? patient.name[0].text = row[62] : null;
//   //these are the columns that state the dose evaluation status and reason, if available
//   for (final eval in [12, 18, 24, 30, 36, 42, 48]) {
//     if (row[eval] != '') {
//       {
//         row[eval] != null && row[eval] != ''
//             ? patient.name[0].given
//                 .add('Evaluation_Status_${eval / 6 - 1}: ${row[eval]}')
//             : null;
//         row[eval + 1] != null && row[eval + 1] != ''
//             ? patient.name[0].given
//                 .add('Evaluation_Reason_${eval / 6 - 1}: ${row[eval + 1]}')
//             : null;
//       }
//     }
//   }
//   return patient;
// }

// String getDz(String cvxCode) {
//   var cvx = int.parse(cvxCode);
//   var dz = '';
//   if ([
//     26,
//     172,
//     173,
//     174,
//   ].contains(cvx)) dz == '' ? dz = 'Cholera' : dz += ', Cholera';
//   if ([
//     1,
//     9,
//     20,
//     22,
//     28,
//     50,
//     102,
//     106,
//     107,
//     110,
//     113,
//     115,
//     120,
//     130,
//     132,
//     138,
//     139,
//     146,
//     170,
//     195,
//     196,
//   ].contains(cvx)) dz == '' ? dz = 'Diphtheria' : dz += ', Diphtheria';
//   if ([
//     31,
//     52,
//     83,
//     84,
//     85,
//     104,
//     169,
//     193,
//   ].contains(cvx)) dz == '' ? dz = 'HepA' : dz += ', HepA';
//   if ([
//     8,
//     42,
//     43,
//     44,
//     45,
//     51,
//     102,
//     104,
//     110,
//     132,
//     146,
//     189,
//     193,
//   ].contains(cvx)) dz == '' ? dz = 'HepB' : dz += ', HepB';
//   if ([
//     17,
//     22,
//     46,
//     47,
//     48,
//     49,
//     50,
//     51,
//     102,
//     120,
//     132,
//     146,
//     148,
//     170,
//   ].contains(cvx)) dz == '' ? dz = 'Hib' : dz += ', Hib';
//   if ([
//     62,
//     118,
//     137,
//     165,
//   ].contains(cvx)) dz == '' ? dz = 'HPV' : dz += ', HPV';
//   if ([
//     15,
//     16,
//     88,
//     111,
//     135,
//     140,
//     141,
//     144,
//     149,
//     150,
//     151,
//     153,
//     155,
//     158,
//     161,
//     166,
//     168,
//     171,
//     185,
//     186,
//     194,
//   ].contains(cvx)) dz == '' ? dz = 'Influenza' : dz += ', Influenza';
//   if ([
//     39,
//     129,
//     134,
//   ].contains(cvx)) {
//     dz == '' ? dz = 'Japanese Encephalitis' : dz += ', Japanese Encephalitis';
//   }
//   if ([
//     3,
//     4,
//     5,
//     94,
//   ].contains(cvx)) dz == '' ? dz = 'Measles' : dz += ', Measles';
//   if ([
//     32,
//     103,
//     108,
//     114,
//     136,
//     147,
//     148,
//     167,
//     191,
//     192,
//   ].contains(cvx)) dz == '' ? dz = 'Meningococcal' : dz += ', Meningococcal';
//   if ([
//     162,
//     163,
//     164,
//     167,
//   ].contains(cvx)) {
//     dz == '' ? dz = 'Meningococcal B' : dz += ', Meningococcal B';
//   }
//   if ([
//     3,
//     7,
//     38,
//     94,
//   ].contains(cvx)) dz == '' ? dz = 'Mumps' : dz += ', Mumps';
//   if ([
//     1,
//     11,
//     20,
//     22,
//     50,
//     102,
//     106,
//     107,
//     110,
//     115,
//     120,
//     130,
//     132,
//     146,
//     170,
//   ].contains(cvx)) dz == '' ? dz = 'Pertussis' : dz += ', Pertussis';
//   if ([
//     33,
//     100,
//     109,
//     133,
//     152,
//     177,
//   ].contains(cvx)) dz == '' ? dz = 'Pneumococcal' : dz += ', Pneumococcal';
//   if ([
//     2,
//     10,
//     89,
//     110,
//     120,
//     130,
//     132,
//     146,
//     170,
//     178,
//     179,
//     182,
//     195,
//   ].contains(cvx)) dz == '' ? dz = 'Polio' : dz += ', Polio';
//   if ([18, 40, 90, 175, 176].contains(cvx)) {
//     dz == '' ? dz = 'Rabies' : dz += ', Rabies';
//   }
//   if ([
//     74,
//     116,
//     119,
//     122,
//   ].contains(cvx)) dz == '' ? dz = 'Rotavirus' : dz += ', Rotavirus';
//   if ([
//     3,
//     4,
//     6,
//     38,
//     94,
//   ].contains(cvx)) dz == '' ? dz = 'Rubella' : dz += ', Rubella';
//   if ([
//     1,
//     9,
//     20,
//     22,
//     28,
//     35,
//     50,
//     102,
//     106,
//     107,
//     110,
//     112,
//     113,
//     115,
//     120,
//     130,
//     132,
//     138,
//     139,
//     142,
//     146,
//     170,
//     195,
//     196,
//   ].contains(cvx)) dz == '' ? dz = 'Tetanus' : dz += ', Tetanus';
//   if ([
//     25,
//     41,
//     53,
//     91,
//     101,
//     190,
//   ].contains(cvx)) dz == '' ? dz = 'Typhoid' : dz += ', Typhoid';
//   if ([
//     21,
//     94,
//     121,
//   ].contains(cvx)) dz == '' ? dz = 'Varicella' : dz += ', Varicella';
//   if ([
//     37,
//     183,
//     184,
//   ].contains(cvx)) dz == '' ? dz = 'Yellow Fever' : dz += ', Yellow Fever';
//   if ([
//     121,
//     187,
//     188,
//   ].contains(cvx)) dz == '' ? dz = 'Zoster' : dz += ', Zoster';
//   return dz;
// }
