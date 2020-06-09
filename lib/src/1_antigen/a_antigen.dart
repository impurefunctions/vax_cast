import 'package:vax_cast/src/9_shared/shared.dart';

part 'b_immunity.dart';
part 'c_contraindication.dart';

class Antigen {
  String seriesVaccineGroup;
  List<Group> groups;
  bool immunity;
  bool contraindicated;
  VaxPatient patient;
  String targetDisease;

  Antigen(
    this.patient,
    this.targetDisease,
  );

  void newSeries(Series series) {
    if (series?.seriesDose != null) {
      if (groups == null) {
        groups = <Group>[Group(series, patient)];
        seriesVaccineGroup = series.seriesVaccineGroup;
      } else {
        var group = groups.firstWhere(
            (group) => group.seriesGroup == series.seriesGroup,
            orElse: () => null);
        group == null
            ? groups.add(Group(series, patient))
            : group.vaxSeries.add(VaxSeries(series, patient));
      }
    }
  }

  bool isSingleAgVaxGroup() =>
      seriesVaccineGroup != 'MMR' && seriesVaccineGroup != 'DTAP';

  void getForecast() {
    groups.forEach((group) {
      group.evaluateAllPatientSeries();
      immunity = checkForImmunity(immunity, patient, targetDisease);
      contraindicated =
          checkAntigenContraindication(contraindicated, patient, targetDisease);
      group.forecastEachSeries(immunity, contraindicated);
    });
    groups.removeWhere((group) => group.vaxSeries.isEmpty);
    groups.forEach((group) => group.selectPatientSeries());
    groups.retainWhere((group) => group.prioritizedSeries != -1);
    groups.forEach((group) => group.isItABestSeries(groups));
    groups.retainWhere((group) => group.bestGroup);
    // groups.forEach((group) => group.vaxSeries.forEach((series) { 
    //   print(series.seriesName);
    //   print(series.targetDoses);
    // }));
  }
}
