import 'package:vax_cast/src/shared.dart';

part 'b_sort_by_antigen.dart';

class VaxCast {
  VaxPatient patient;
  Map<VaxAg, Antigen> ag;

  VaxCast() {
    VaxAg.values.forEach((antigen) => ag[antigen] = Antigen());
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
    ag.forEach((k, v) {
      v.sortDoses();
      v.selectRelevantSeries(patient, k);
    });

    ag.forEach((k, v) {
      print(k);
      print(v.pastDoses.length);
    });
  }
}
