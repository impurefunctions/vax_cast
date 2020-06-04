part of 'a_vax_series.dart';

bool isRecurring(List<SeriesDose> seriesDose, int targetDose) =>
    targetDose + 1 == seriesDose.length &&
    seriesDose.last.recurringDose == 'Yes';

Tuple2<SeriesStatus, TargetStatus> completeRecurringDose(
    SeriesDose seriesDose, TargetStatus status, VaxDate dateGiven) {
  SeasonalRecommendation seasonRec = seriesDose.seasonalRecommendation;
  return seasonRec == null
      ? Tuple2(null, TargetStatus.not_satisfied)
      : status == TargetStatus.skipped
          ? Tuple2(SeriesStatus.complete, status)
          : VaxDate.max().fromNullableString(seasonRec.endDate) > dateGiven &&
                  VaxDate.min().fromNullableString(seasonRec.startDate) <
                      dateGiven
              ? Tuple2(SeriesStatus.complete, status)
              : Tuple2(null, TargetStatus.not_satisfied);
}

Tuple2<SeriesStatus, TargetStatus> completeNonRecurringDose(
    List<SeriesDose> seriesDose, TargetStatus status, int targetDose) {
  if (seriesDose[targetDose - 1].seasonalRecommendation != null) {
    return status == TargetStatus.not_satisfied
        ? Tuple2(null, TargetStatus.not_satisfied)
        : Tuple2(null, status);
  } else {
    return targetDose == seriesDose.length
        ? Tuple2(SeriesStatus.complete, status)
        : Tuple2(null, status);
  }
}
