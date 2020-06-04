import 'package:vax_cast/src/shared.dart';

class VaxCast {
  VaxPatient patient;

  VaxCast({this.patient});

  void cast(
    version,
    bundles,
    newPatient,
    immunizations,
    recommendations,
    conditions,
    allergyIntolerance,
  ) async {
    await SupportingData.load();
    patient = VaxPatient.fromFhir(
      version,
      bundles,
      newPatient,
      immunizations,
      recommendations,
      conditions,
    );
    patient.pastImmunizations.forEach((element) {
      print(element.dateGiven);
      print(element.cvx);
    });
  }
}
