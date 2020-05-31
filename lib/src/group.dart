import 'supportingData/antigenSupportingData/classes/series.dart';
import 'vaxDate.dart';
import 'vaxPatient/vaxPatient.dart';
import 'vaxSeries.dart';

class Group {
  VaxPatient patient;
  bool anySeriesComplete;
  List<VaxSeries> vaxSeries;
  String equivalentGroups;
  String seriesGroup;
  String highestPriority;
  int numProdValidSeries;
  int numCompletableSeries;
  int highestNumValidDoses;
  int lowestNumDosesFromCompletion;
  int numSeriesClosestToCompletion;
  VaxDate earliestFinishDate;
  int numSeriesWithHighestNumValidDoses;
  int numSeriesFinishingEarliest;
  int numScorableSeries;
  int numSeriesInProcess;
  int numCompleteSeries;
  int defaultSeries;
  int prioritizedSeries;
  bool bestGroup;

  Group(Series series, VaxPatient newPatient) {
    patient = newPatient;
    anySeriesComplete = false;
    vaxSeries = [VaxSeries(series, patient)];

    if (series.equivalentSeriesGroups == null) {
      equivalentGroups = null;
    } else {
      equivalentGroups = series.equivalentSeriesGroups;
    }
    seriesGroup = series.seriesGroup;
    highestPriority = 'Z';
    numProdValidSeries = 0;
    numCompletableSeries = 0;
    highestNumValidDoses = 0;
    lowestNumDosesFromCompletion = 99;
    numSeriesClosestToCompletion = 0;
    earliestFinishDate = VaxDate.max();
    numSeriesWithHighestNumValidDoses = 0;
    numSeriesFinishingEarliest = 0;
    numScorableSeries = 0;
    numSeriesInProcess = 0;
    numCompleteSeries = 0;
    defaultSeries = -1;
    prioritizedSeries = -1;

    bestGroup = false;
  }

//****************************************************************************/
//    Evaluation Section
//****************************************************************************/
  void evaluateAllPatientSeries() => vaxSeries.forEach((series) {
        series.evaluateVaccineDosesAdministered(anySeriesComplete);
        anySeriesComplete &= series.seriesStatus == 'complete';
      });

  void forecastEachSeries(bool immunity, bool contraindicated) {
    for (final series in vaxSeries) {
      if (immunity) {
        series.seriesStatus = 'immune';
      } else {
        series.checkForSkippable(anySeriesComplete);
        if (series.seriesStatus == 'not complete') {
          series.checkContraindication();
          if (series.shouldReceiveAnotherTargetDose(
              immunity, contraindicated)) {
            series.generateForecastDates(anySeriesComplete);
            setHighestPriority(series.seriesPriority);
          }
        }
      }
    }
  }

  void setHighestPriority(String priority) => highestPriority =
      priority.compareTo(highestPriority) == -1 ? priority : highestPriority;

//****************************************** */
//    Selection Section
//****************************************** */
  void selectPatientSeries() {
    preFilterPatientSeries();
    getScoreableNumbers();
    findOnePrioritizedSeries();
    if (prioritizedSeries == -1) {
      classifyAndScoreSeries();
      getPrioritizedFromScore();
    }
    vaxSeries = [vaxSeries[prioritizedSeries]];
  }

  void preFilterPatientSeries() {
    for (final series in vaxSeries) {
      series.preFilterPatientSeries(highestPriority);
    }
  }

  void getScoreableNumbers() {
    for (final series in vaxSeries) {
      numCompleteSeries += series.seriesStatus == 'complete' ? 1 : 0;
      numScorableSeries +=
          series.scorableSeries == null ? 0 : series.scorableSeries ? 1 : 0;
      numSeriesInProcess +=
          series.targetDose != 0 && series.seriesStatus == 'not complete'
              ? 1
              : 0;
    }
  }

  void findOnePrioritizedSeries() {
    defaultSeries = vaxSeries.indexWhere((series) => series.isDefaultSeries);
    if (numScorableSeries == 0 && defaultSeries != -1) {
      prioritizedSeries = defaultSeries;
    } else if (numScorableSeries == 1) {
      prioritizedSeries =
          vaxSeries.indexWhere((series) => series.scorableSeries);
    } else if (numCompleteSeries == 1) {
      prioritizedSeries =
          vaxSeries.indexWhere((series) => series.seriesStatus == 'complete');
    } else if (numSeriesInProcess == 1) {
      prioritizedSeries =
          vaxSeries.indexWhere((series) => series.targetDose != 0);
    } else if (numSeriesInProcess == 0 && defaultSeries != -1) {
      prioritizedSeries = defaultSeries;
    }
  }

  void classifyAndScoreSeries() {
    if (numCompleteSeries >= 2) {
      vaxSeries.forEach((series) =>
          series.shouldBeScored = series.seriesStatus == 'complete');
      vaxSeries.retainWhere((series) => series.shouldBeScored);
      scoreAllCompletedPatientSeries();
    } else if (numSeriesInProcess >= 2) {
      vaxSeries.forEach((series) => series.shouldBeScored =
          series.targetDose != 0 && series.seriesStatus == 'not complete');
      vaxSeries.retainWhere((series) => series.shouldBeScored);
      scoreInProcessPatientSeries();
    } else {
      vaxSeries.forEach((series) => series.shouldBeScored = true);
      scoreNoValidDoses();
    }
  }

  void getPrioritizedFromScore() {
    var score = -99;
    var numHighestScore = 0;
    var highestPreference = 99;
    vaxSeries.forEach(
        (series) => score = score > series.score ? score : series.score);
    vaxSeries.forEach((series) {
      numHighestScore += score == series.score ? 1 : 0;
      highestPreference = highestPreference < int.parse(series.seriesPreference)
          ? highestPreference
          : int.parse(series.seriesPreference);
    });
    if (numHighestScore > 1) {
      prioritizedSeries = vaxSeries.indexWhere((series) =>
          series.score == score &&
          int.parse(series.seriesPreference) == highestPreference);
      vaxSeries[prioritizedSeries].prioritized = true;
    } else {
      prioritizedSeries =
          vaxSeries.indexWhere((series) => series.score == score);
    }
  }

  void scoreNoValidDoses() {
    vaxSeries.forEach((series) {
      series.prepareToScoreSeries();
      getEarliestStartDate(series);
      getNumCompletableSeries(series);
      getNumProdSeries(series);
    });
    vaxSeries.forEach((series) {
      getNumSeriesFinishingEarliest(series);
      getNumCompletableSeries(series);
    });
    if (numSeriesFinishingEarliest == 1) {
      awardNumSeriesStartingEarliest(1);
    }
    if (numCompletableSeries == 1) {
      awardNumCompletableSeries(1);
    }
    if (numProdValidSeries == 1) {
      awardNumProdValidSeries(-1);
    }
    vaxSeries.forEach((series) {
      series.notEarliestToStart(earliestFinishDate, -1);
      series.notCompletable(-1);
      series.notProdSeries(1);
    });
  }

  void scoreAllCompletedPatientSeries() {
    vaxSeries.forEach((series) {
      series.prepareToScoreSeries();
      getHighestNumValidDoses(series);
      getNumProdValidSeries(series);
      getEarliestFinishDate(series);
    });

    vaxSeries.forEach((series) {
      getNumSeriesWithHighestNumValidDoses(series);
      getNumSeriesFinishingEarliest(series);
    });
    if (numSeriesWithHighestNumValidDoses == 1) {
      awardNumSeriesWithHighestNumValidDoses(1);
    }
    if (numProdValidSeries == 1) {
      awardNumProdValidSeries(1);
    }
    if (numSeriesFinishingEarliest == 1) {
      awardNumSeriesFinishingEarliest(2);
    }
    vaxSeries.forEach((series) {
      series.notProdValidSeries(-1);
      series.notHighestNumValidDoses(highestNumValidDoses, -1);
      series.notEarliestToFinish(earliestFinishDate, -1);
    });
  }

  void scoreInProcessPatientSeries() {
    vaxSeries.forEach((series) {
      series.prepareToScoreSeries();
      getNumProdValidSeries(series);
      getHighestNumValidDoses(series);
      getEarliestFinishDate(series);
      getNumCompletableSeries(series);
      getLowestNumDosesFromCompletion(series);
    });
    vaxSeries.forEach((series) {
      getNumSeriesWithHighestNumValidDoses(series);
      getNumSeriesClosestToCompletion(series);
      getNumSeriesFinishingEarliest(series);
    });
    if (numProdValidSeries == 1) {
      awardNumProdValidSeries(2);
    }
    if (numCompletableSeries == 1) {
      awardNumCompletableSeries(3);
    }
    if (numSeriesWithHighestNumValidDoses == 1) {
      awardNumSeriesWithHighestNumValidDoses(2);
    }
    if (numSeriesClosestToCompletion == 1) {
      awardNumSeriesClosestToCompletion(2);
    }
    if (numSeriesFinishingEarliest == 1) {
      awardNumSeriesFinishingEarliest(1);
    }
    vaxSeries.forEach((series) {
      series.notProdValidSeries(-2);
      series.notCompletable(-3);
      series.notHighestNumValidDoses(highestNumValidDoses, -2);
      series.notClosestToCompletion(lowestNumDosesFromCompletion, -2);
      series.notEarliestToFinish(earliestFinishDate, -1);
    });
  }

  //I know I should just add another field, but this will be my idiosyncrasy
  void getEarliestStartDate(VaxSeries series) => earliestFinishDate =
      earliestFinishDate <= series.recommendedDose.earliestDate
          ? earliestFinishDate
          : series.recommendedDose.earliestDate;

  void getNumProdSeries(VaxSeries series) =>
      numProdValidSeries += series.isProductSeries ? 1 : 0;

  void getHighestNumValidDoses(VaxSeries series) =>
      highestNumValidDoses = highestNumValidDoses >= series.targetDose
          ? highestNumValidDoses
          : series.targetDose;

  void getNumProdValidSeries(VaxSeries series) => numProdValidSeries +=
      series.isProductSeries && series.allDosesValid ? 1 : 0;

  void getNumCompletableSeries(VaxSeries series) =>
      numCompletableSeries += series.completeable ? 1 : 0;

  void getEarliestFinishDate(VaxSeries series) =>
      earliestFinishDate = earliestFinishDate <= series.forecastFinishDate
          ? earliestFinishDate
          : series.forecastFinishDate;

  void getNumSeriesWithHighestNumValidDoses(VaxSeries series) =>
      numSeriesWithHighestNumValidDoses +=
          series.targetDose == highestNumValidDoses ? 1 : 0;

  void getNumSeriesFinishingEarliest(VaxSeries series) =>
      numSeriesFinishingEarliest +=
          series.forecastFinishDate == earliestFinishDate ? 1 : 0;

  void getLowestNumDosesFromCompletion(VaxSeries series) =>
      lowestNumDosesFromCompletion = lowestNumDosesFromCompletion <=
              (series.seriesDose.length - series.targetDose + 1)
          ? lowestNumDosesFromCompletion
          : series.seriesDose.length - series.targetDose + 1;

  void getNumSeriesClosestToCompletion(VaxSeries series) =>
      numSeriesClosestToCompletion +=
          series.seriesDose.length - series.targetDose + 1 ==
                  lowestNumDosesFromCompletion
              ? 1
              : 0;

  void awardNumProdValidSeries(int points) => vaxSeries
      .firstWhere((series) => series.isProductSeries && series.allDosesValid)
      .score += points;

  void awardNumCompletableSeries(int points) =>
      vaxSeries.firstWhere((series) => series.completeable).score += points;

  void awardNumSeriesWithHighestNumValidDoses(int points) => vaxSeries
      .firstWhere((series) => series.targetDose == highestNumValidDoses)
      .score += points;

  void awardNumSeriesClosestToCompletion(int points) => vaxSeries
      .firstWhere((series) =>
          series.seriesDose.length - series.targetDose + 1 ==
          lowestNumDosesFromCompletion)
      .score += points;

  void awardNumSeriesFinishingEarliest(int points) => vaxSeries
      .firstWhere((series) => series.forecastFinishDate == earliestFinishDate)
      .score += points;

  void awardNumSeriesStartingEarliest(int points) => vaxSeries
      .firstWhere(
          (series) => series.recommendedDose.earliestDate == earliestFinishDate)
      .score += points;

  void isItABestSeries(List<Group> groups) {
    vaxSeries[0].isItABestSeries(groups, equivalentGroups);
    bestGroup = vaxSeries[0].bestSeries;
  }
}
