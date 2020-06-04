part of 'a_vax_series.dart';

class PrepareSeries {
  bool allDosesValid;
  VaxDate forecastFinishDate;
  bool completable;

  PrepareSeries();

  void toScore(VaxSeries series) {
    VaxDate dob = series.patient.dob;
    List<SeriesDose> seriesDose = series.seriesDose;
    allDosesValid = series.pastDoses.indexWhere((dose) => !dose.valid) == -1;
    if (series.seriesStatus == SeriesStatus.complete) {
      forecastFinishDate = VaxDate.min();
    } else {
      forecastFinishDate = series.recommendedDose.earliestDate;
      for (var i = series.targetDose + 1; i < seriesDose.length; i++) {
        if (seriesDose[i].interval != null) {
          if (seriesDose[i].interval[0].fromPrevious == 'Y') {
            forecastFinishDate =
                forecastFinishDate.change(seriesDose[i].interval[0].absMinInt);
          }
        }
        forecastFinishDate =
            forecastFinishDate > dob.minIfNull(seriesDose[i].age[0].absMinAge)
                ? forecastFinishDate
                : dob.minIfNull(seriesDose[i].age[0].absMinAge);
      }
    }
    completable =
        forecastFinishDate < dob.maxIfNull(seriesDose.last.age[0].maxAge);
  }
}
