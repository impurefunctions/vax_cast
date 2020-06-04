import 'package:vax_cast/src/shared.dart';

part 'b_sort_by_antigen.dart';

class VaxCast {
  VaxPatient patient;
  Map<Dz, Antigen> ag;

  VaxCast() {
    ag = <Dz, Antigen>{};
  }

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

    ag = sortByAntigen(patient);
    getAllAntigens();
    ag.forEach((dz, antigen) {
      antigen.sortDoses();
      antigen.createRelevantSeries(patient, dz);
    });
    ag.removeWhere((dz, antigen) =>
        antigen?.pastDoses?.isEmpty ?? true && antigen.series.isEmpty);

    ag.forEach((dz, antigen) => antigen.evaluateDoses(patient));

    ag.forEach((k, v) {
      print(k.toString());
      v.series.forEach((element) {
        print(element.targetDoses);
      });
      print(v.series.length);
    });
  }

  void getAllAntigens() {
    SupportingData.antigenSupportingData.keys.forEach((disease) {
      if (!ag.keys.contains(Dz.parse(disease)))
        ag[Dz.parse(disease)] = Antigen();
    });
  }
}
