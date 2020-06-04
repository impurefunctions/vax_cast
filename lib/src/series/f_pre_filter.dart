part of 'a_vax_series.dart';

abstract class PreFilter {
  static bool scorable(
    VaxSeries series,
    String highPriority,
  ) =>
      highEnoughPriority(series.seriesPriority, highPriority) &&
      isOldEnough(series.patient.dob, series.patient.assessmentDate,
          series.minAgeToStart, series.seriesStatus) &&
      startedOnTime(series.pastDoses, series.patient.dob, series.maxAgeToStart);

  static bool highEnoughPriority(String seriesPriority, String highPriority) =>
      seriesPriority.compareTo(highPriority) != 1;

  static bool isOldEnough(VaxDate dob, VaxDate assessmentDate,
          String minAgeToStart, SeriesStatus status) =>
      dob.minIfNull(minAgeToStart) <= assessmentDate ||
      status == SeriesStatus.complete;

  static bool startedOnTime(
      List<Dose> pastDoses, VaxDate dob, String maxAgeToStart) {
    if (pastDoses.isEmpty) return true;
    int dose = pastDoses.indexWhere((dose) => dose.valid);
    return dose == -1
        ? true
        : pastDoses[dose].dateGiven < dob.maxIfNull(maxAgeToStart);
  }
}
