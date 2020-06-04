import 'package:vax_cast/src/shared.dart';

part 'b_scorable.dart';
part 'c_prioritized.dart';
part 'd_complete_series.dart';
part 'e_in_process_series.dart';
part 'f_no_valid_doses.dart';
part 'g_scoring.dart';

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
    series.equivalentSeriesGroups == null
        ? equivalentGroups = null
        : equivalentGroups = series.equivalentSeriesGroups;
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

  void evaluateAllPatientSeries() => vaxSeries.forEach((series) {
        series.evaluateVaccineDosesAdministered(anySeriesComplete);
        anySeriesComplete &= series.seriesStatus == SeriesStatus.complete;
      });

  void forecastEachSeries(bool immunity, bool contraindicated) {
    for (final series in vaxSeries) {
      if (immunity) {
        series.seriesStatus = SeriesStatus.immune;
      } else {
        series.checkForSkippable(anySeriesComplete);
        if (series.seriesStatus == SeriesStatus.not_complete) {
          series.checkContraindication();
          series.shouldReceiveAnotherTargetDose(immunity, contraindicated);
          if (series.anotherDose) {
            series.generateForecastDates(anySeriesComplete);
            highestPriority =
                series.seriesPriority.compareTo(highestPriority) == -1
                    ? series.seriesPriority
                    : highestPriority;
          }
        }
      }
    }
  }

  void selectPatientSeries() {
    vaxSeries.forEach((series) => series.preFilterSeries(highestPriority));
    Scorable scorable = Scorable();
    scorable.getNumbers(vaxSeries);
    defaultSeries = vaxSeries.indexWhere((series) => series.isDefaultSeries);
    prioritizedSeries = Prioritized.findOne(defaultSeries, scorable, vaxSeries);
    if (prioritizedSeries == -1) {
      classifyAndScoreSeries();
      getPrioritizedFromScore();
    }
    vaxSeries = [vaxSeries[prioritizedSeries]];
  }

  void classifyAndScoreSeries() {
    vaxSeries = numCompleteSeries >= 2
        ? CompleteSeries.scoreAll(vaxSeries)
        : numSeriesInProcess >= 2
            ? InProcessSeries.scoreAll(vaxSeries)
            : vaxSeries = NoValidDoses.scoreAll(vaxSeries);
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

  void isItABestSeries(List<Group> groups) {
    vaxSeries[0].isItABestSeries(groups, equivalentGroups);
    bestGroup = vaxSeries[0].bestSeries;
  }
}
