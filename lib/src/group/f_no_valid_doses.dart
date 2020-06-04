part of 'a_group.dart';

abstract class NoValidDoses {
  static List<VaxSeries> scoreAll(List<VaxSeries> vaxSeries) {
    VaxDate earliestStartDate = VaxDate.max();
    int numCompletableSeries = 0;
    int numProdSeries = 0;

    vaxSeries.forEach((series) {
      series.prepareToScoreSeries();
      earliestStartDate =
          Scoring.getEarliestStartDate(series, earliestStartDate);
      numCompletableSeries =
          Scoring.getNumCompletableSeries(series, numCompletableSeries);
      numProdSeries = Scoring.getNumProdSeries(series, numProdSeries);
    });

    int numSeriesStartingEarliest = 0;

    vaxSeries.forEach((series) {
      numSeriesStartingEarliest = Scoring.getNumSeriesStartingEarliest(
        series,
        numSeriesStartingEarliest,
        earliestStartDate,
      );
    });

    if (numSeriesStartingEarliest == 1) {
      vaxSeries = Scoring.awardNumSeriesStartingEarliest(
        1,
        vaxSeries,
        earliestStartDate,
      );
    }
    if (numCompletableSeries == 1) {
      vaxSeries = Scoring.awardNumCompletableSeries(1, vaxSeries);
    }
    if (numProdSeries == 1) {
      vaxSeries = Scoring.awardNumProdValidSeries(-1, vaxSeries);
    }

    vaxSeries.forEach((series) {
      series.score = Scoring.notEarliestToStart(
        earliestStartDate,
        -1,
        series.score,
        series.recommendedDose.earliestDate,
      );
      series.score = Scoring.notCompletable(
        -1,
        series.score,
        series.completable,
      );
      series.score = Scoring.notProdSeries(
        1,
        series.score,
        series.isProductSeries,
      );
    });
  }
}
