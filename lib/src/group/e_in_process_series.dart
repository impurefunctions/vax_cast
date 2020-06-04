part of 'a_group.dart';

abstract class InProcessSeries {
  static List<VaxSeries> scoreAll(List<VaxSeries> vaxSeries) {
    vaxSeries.retainWhere((series) =>
        series.targetDose != 0 &&
        series.seriesStatus == SeriesStatus.not_complete);
    return scoreInProcessPatientSeries(vaxSeries);
  }

  static List<VaxSeries> scoreInProcessPatientSeries(
      List<VaxSeries> vaxSeries) {
    int highestNumValidDoses = 0;
    int numProdValidSeries = 0;
    VaxDate earliestFinishDate = VaxDate.max();
    int numCompletableSeries = 0;
    int lowestNumDosesFromCompletion = 0;

    vaxSeries.forEach((series) {
      series.prepareToScoreSeries();
      highestNumValidDoses =
          Scoring.getHighestNumValidDoses(series, highestNumValidDoses);
      numProdValidSeries =
          Scoring.getNumProdValidSeries(series, numProdValidSeries);
      earliestFinishDate =
          Scoring.getEarliestFinishDate(series, earliestFinishDate);
      numCompletableSeries =
          Scoring.getNumCompletableSeries(series, numCompletableSeries);
      lowestNumDosesFromCompletion = Scoring.getLowestNumDosesFromCompletion(
          series, lowestNumDosesFromCompletion);
    });

    int numSeriesWithHighestNumValidDoses = 0;
    int numSeriesFinishingEarliest = 0;
    int numSeriesClosestToCompletion = 0;

    vaxSeries.forEach((series) {
      numSeriesWithHighestNumValidDoses =
          Scoring.getNumSeriesWithHighestNumValidDoses(
        series,
        numSeriesWithHighestNumValidDoses,
        highestNumValidDoses,
      );

      numSeriesClosestToCompletion = Scoring.getNumSeriesClosestToCompletion(
        series,
        numSeriesClosestToCompletion,
        lowestNumDosesFromCompletion,
      );

      numSeriesFinishingEarliest = Scoring.getNumSeriesFinishingEarliest(
        series,
        numSeriesFinishingEarliest,
        earliestFinishDate,
      );
    });

    if (numProdValidSeries == 1) {
      vaxSeries = Scoring.awardNumProdValidSeries(
        2,
        vaxSeries,
      );
    }

    if (numCompletableSeries == 1) {
      vaxSeries = Scoring.awardNumCompletableSeries(3, vaxSeries);
    }

    if (numSeriesWithHighestNumValidDoses == 1) {
      vaxSeries = Scoring.awardNumSeriesWithHighestNumValidDoses(
        2,
        vaxSeries,
        highestNumValidDoses,
      );
    }
    if (numSeriesClosestToCompletion == 1) {
      vaxSeries = Scoring.awardNumSeriesClosestToCompletion(
        2,
        vaxSeries,
        lowestNumDosesFromCompletion,
      );
    }

    if (numSeriesFinishingEarliest == 1) {
      vaxSeries = Scoring.awardNumSeriesFinishingEarliest(
        1,
        vaxSeries,
        earliestFinishDate,
      );
    }

    vaxSeries.forEach((series) {
      series.score = Scoring.notProdValidSeries(
        -2,
        series.score,
        series.isProductSeries,
        series.allDosesValid,
      );
      series.score = Scoring.notCompletable(
        -3,
        series.score,
        series.completable,
      );
      series.score = Scoring.notHighestNumValidDoses(
        highestNumValidDoses,
        -2,
        series.score,
        series.targetDose,
      );
      series.score = Scoring.notClosestToCompletion(
        lowestNumDosesFromCompletion,
        -2,
        series.score,
        series.seriesDose.length,
        series.targetDose,
      );
      series.score = Scoring.notEarliestToFinish(
        earliestFinishDate,
        -1,
        series.score,
        series.forecastFinishDate,
      );
    });

    return vaxSeries;
  }
}
