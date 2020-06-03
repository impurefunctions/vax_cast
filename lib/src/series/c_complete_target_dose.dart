part of 'a_vax_series.dart';

class CompleteTargetDose {
  TargetStatus status;
  VaxDate dateGiven;
  int targetDose;
  List<SeriesDose> seriesDose;
  SeriesStatus seriesStatus;
  List<TargetStatus> targetDoses;

  CompleteTargetDose(
    this.status,
    this.dateGiven,
    this.targetDose,
    this.seriesDose,
    this.seriesStatus,
    this.targetDoses,
  );

  void completeTargetDose() {
    targetDose += 1;
    targetDose == seriesDose.length && seriesDose.last.recurringDose == 'Yes'
        ? completeRecurringDose()
        : completeNonRecurringDose();
  }

  void completeRecurringDose() {
    SeasonalRecommendation seasonRec = seriesDose.last.seasonalRecommendation;
    seasonRec == null
        ? targetDose -= 1
        : status == TargetStatus.skipped
            ? {
                seriesStatus = SeriesStatus.complete,
                targetDoses[targetDose - 1] = status,
              }
            : VaxDate.max().fromNullableString(seasonRec.endDate) > dateGiven &&
                    VaxDate.min().fromNullableString(seasonRec.startDate) <
                        dateGiven
                ? {
                    seriesStatus = SeriesStatus.complete,
                    targetDoses[targetDose - 1] = status,
                  }
                : targetDose -= 1;
  }

  void completeNonRecurringDose() {
    if (seriesDose[targetDose - 1].seasonalRecommendation != null) {
      status == TargetStatus.not_satisfied
          ? targetDose -= 1
          : targetDoses[targetDose - 1] = status;
    } else {
      if (targetDose == seriesDose.length) {
        seriesStatus = SeriesStatus.complete;
      }
      targetDoses[targetDose - 1] = status;
    }
  }
}
