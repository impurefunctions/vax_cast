import 'dart:convert';
import 'package:http/http.dart';

import 'package:fhir/fhir_r4.dart';

Future<List<Bundle>> GetRemotePatientData(String patientId) async {
  var server = 'https://r4immunizationtesting.aidbox.app/';
  var headers = await getAuthorizationToken(server);

  var patientBundle = await getPatientBundle(server, headers, patientId);
  var immunizationBundle =
      await getImmunizationBundle(server, headers, patientId);
  var recommendationBundle =
      await getRecommendationBundle(server, headers, patientId);
  var conditionBundle = await getConditionBundle(server, headers, patientId);

  return ([
    patientBundle,
    immunizationBundle,
    recommendationBundle,
    conditionBundle,
  ]);
}

Future<Map<String, String>> getAuthorizationToken(String server) async {
  var headers = {'Content-type': 'application/json'};
  var identifier = 'vaccineTest';
  var secret = 'verysecret';

  var response = await post(
      '$server/auth/token?client_id=$identifier&grant_type=client_credentials&client_secret=$secret',
      headers: headers);
  if (response.statusCode == 200) {
    var parsedbody = json.decode(response.body);
    var token = parsedbody['token_type'] + ' ' + parsedbody['access_token'];
    headers.putIfAbsent('Authorization', () => token);
  }
  return headers;
}

Future<Bundle> getPatientBundle(
        String server, Map<String, String> headers, String patientId) async =>
    bundleFromGet('$server/fhir/Patient?id=$patientId', headers);

Future<Bundle> getImmunizationBundle(
        String server, Map<String, String> headers, String patientId) async =>
    bundleFromGet('$server/fhir/Immunization?patient=$patientId', headers);

Future<Bundle> getRecommendationBundle(
        String server, Map<String, String> headers, String patientId) async =>
    bundleFromGet(
        '$server/fhir/ImmunizationRecommendation?patient=$patientId', headers);

Future<Bundle> getConditionBundle(
        String server, Map<String, String> headers, String patientId) async =>
    bundleFromGet('$server/fhir/Condition?patient=$patientId', headers);

Future<Bundle> bundleFromGet(String url, Map<String, String> headers) async =>
    Bundle.fromJson(json.decode((await get(url, headers: headers)).body));
