# Chapter 6 Select Patient Series

### Another quick note, because it hasn't really been dealt with before, this section is going ot start using the Series Group in part of the logic. There are Vaccine Groups (MMR, Tdap, etc), which are broken down into antigens. Each antigen has multiple series that apply to it. However, these series can be grouped together. At the beginning of each series, it looks like the code below. The seriesGroup is what we're talking about.

```
"series": [
    {
        "seriesName": "HepA 2-dose series",
        "targetDisease": "HepA",
        "seriesVaccineGroup": "HepA",
        "seriesAdminGuidance": null,
        "seriesType": "Standard",
        "equivalentSeriesGroups": "2",
        "requiredGender": null,
        "defaultSeries": "Yes",
        "productPath": "No",
        "seriesGroupName": "Standard",
        "seriesGroup": "1",
        "seriesPriority": "A",
        "seriesPreference": "1",
        "minAgeToStart": null,
        "maxAgeToStart": "19 years",
        "indication": null,
        "seriesDose": [
```

## 6.1 Pre-filter Patient Series

_A relevant patient series must be considered a scorable patient series_... Remember a relevant patient series is just one of the series that we determined could be a viable option for the patient when we began this whole thing. At the beginning when we filtered out the series that weren't applicable to the patient, all that we were left with are relevant series. So the series we've been evaluating up to this point are all relevant series. We're now going to filter some more out, and the series that we will be left with will be scorable series (we're going to be assigning scores to each of them in the near future). So, back to it, 

_A relevant patient series must be considered a scorable patient series if all of the following are true_.
<ul><li> The series must have the same or greater priority as other series being considered. For each series, there is a field "seriesPriority", these are marked with letters, "A", "B", "C", etc. If any possible series have an "A" seriesPriority, than the only series we're going to consider from now on must also have "A" priority. If the highest is "B", than all must have a "B" priority, etc. <li> Patient meets starting age requirements (each series has a minimum starting age field) <li> Date administered of the first dose in the series must have been given bfore the maximum age to start date, or if this is the first dose, than the patient must be younger than the maximum age to start date) </ul>

allSeriesForAg.dart

```
  preFilterPatientSeries() => singleVaccineSeries.forEach((series) {
        series.preFilterPatientSeries(_getHighestPriority());
      });

  String _getHighestPriority() {
    var priority = 'Z';
    singleVaccineSeries.forEach((series) => priority =
        series.series.seriesPriority.compareTo(priority) == -1
            ? series.series.seriesPriority
            : priority);
    return priority;
  }
```

singleVaccineSeries.dart

```
  preFilterPatientSeries(String highPriority) {
    var assessmentDate = VaccinePatient.assessmentDate;
    var dob = VaccinePatient.dob;
    bool _highEnoughPriority(String highPriority) =>
        priority.compareTo(highPriority) != 1;

    bool _isOldEnough(VaxDate assessmentDate) =>
        dob.minIfNull(series.minAgeToStart) <= assessmentDate;

    bool _startedOnTime(VaxDate assessmentDate) {
      var dose = Dose.indexWhere((dose) => dose.valid);
      if (dose == -1) {
        return assessmentDate < dob.minIfNull(series.maxAgeToStart);
      } else {
        return Dose[dose].dateGiven <
            dob.minIfNull(series.maxAgeToStart);
      }
    }

    if (_highEnoughPriority(highPriority) &&
        _isOldEnough(VaccinePatient.assessmentDate) &&
        _startedOnTime(assessmentDate)) {
      scorableSeries = true;
    } else {
      scorableSeries = false;
    }
  }
```

## 6.2 Identify One Prioritized Patient Series

So as I understand it, this may end our quest of the best series. I didn't realize this at first, but after evaluating this diagram, I think it does. 
![Figure ](https://github.com/Dokotela/FhirVCA/blob/master/documentation/images/8-2%20Select%20Prioritized%20Patient%20Series%20Process%20Model.png)
This looks to see if one of the scorable series (except for the first option, note it will look at the other series if there are no scorable series) should be prioritized above the others. If it is, then for that *Series Group* that's the preferred series, and we don't score any of the others (for that series group, if there are still other series groups for that antigen, we **DO** score those.
  * A patient series is 'complete' if the series status is 'complete' (we can also look at the current target dose compared to the number of doses in the series
  * The default series is the series with the entry "defaultSeries": "Yes"
  * An in-process series has at least one target dose that has been satisfied, but the series is not yet complete
  
| Conditions | Rules ||||||
|------------|:-----:|:-----:|:----:|:----:|:----:|:----:|
| There are no series for the antigen that are scorable, but 1 relevant series is identified as the default | Yes | No | No | No | No | No |
| There is only 1 scorable series for that antigen | - | Yes | No | No | No | No |
| There is only 1 complete series for that atigen | - | - | Yes | No | No | No |
| There is only 1 in-process series and no complete series for the antigen | - | - | - | Yes | No | No |
| There are no series for the antigen with any valid doses, but one of the series is the default | - | - | - | - | Yes | No |
| Which series should be prioritized? | Default series | Lone scorable series | Lone complete series | Lone in-process series | Default Series | None, all series are examined to see which should be prioritized |

```
  findOnePrioritizedSeries() {
    singleVaccineSeries.forEach((series) {
      numScorableSeries +=
          series.scorableSeries == null ? 0 : series.scorableSeries ? 1 : 0;
      numSeriesInProcess += series.currentTargetDose != 0 ? 1 : 0;
      numCompleteSeries += series.seriesStatus == 'complete' ? 1 : 0;
    });
    defaultSeries = singleVaccineSeries
        .indexWhere((series) => series.series.defaultSeries == 'Yes');
    if (numScorableSeries == 0 && defaultSeries != -1) {
      singleVaccineSeries[defaultSeries].prioritized = true;
    } else if (numScorableSeries == 1) {
      singleVaccineSeries
          .firstWhere((series) => series.scorableSeries)
          .prioritized = true;
    } else if (numCompleteSeries == 1) {
      singleVaccineSeries
          .firstWhere((series) => series.seriesStatus == 'complete')
          .prioritized = true;
    } else if (numSeriesInProcess == 1) {
      singleVaccineSeries
          .firstWhere((series) => series.currentTargetDose != 0)
          .prioritized = true;
    } else if (numSeriesInProcess == 0 && defaultSeries != -1) {
      singleVaccineSeries[defaultSeries].prioritized = true;
    }
```
## 6.3 Classify Scorable Patient Series

So, if there isn't a prioritized series in that series group, then we have to score them. Within the series group, if there's >= 2 complete series, we score those. If not but there are >= 2 One more step towards filtering out the patient series that we're going to evaluate. Take note that there are different scoring rules for complete series, in-process series and series with 0 valid doses.

| Conditions | Rules |||
|------------|:-----:|:-----:|:----:|
| >= 2 complete series? | Yes | No | No |
| >= 2 in-process series, and 0 complete series? | - | Yes | No |
| Do all series have 0 valid doses? | - | No | Yes |
| Outcomes | Score only the complete patient series | Score only the in-process series | Score all patient series |

```
    if (numCompleteSeries >= 2) {
      singleVaccineSeries.forEach((series) =>
          series.shouldBeScored = series.seriesStatus == 'complete');
    } else if (numSeriesInProcess >= 2) {
      singleVaccineSeries.forEach(
          (series) => series.shouldBeScored = series.currentTargetDose != 0);
    }
    singleVaccineSeries.retainWhere((series) => series.shouldBeScored);
  }
```

## Quick note about scoring.
### We've obtained the relevant series, we've filtered out the scorable series, identified if there is one that is prioritized, and then filtered a number of the series out again. We are now going to look at characteristics of the remaining series, and give the series a score based on those characteristics. The basic math is that if there is only one series for that antigen that meets the condition listed below, they are awarded points for it. If more than one series meet that criteria, then neither of those series is *awarded* any points, but if the series does not meet that condition, than they have points deducted.

## 6.4 Complete Patient Series

| Conditions | True for only 1 scorable series | True for >= 2 scorable series | Not true for scorable series |
|------------|:-----:|:-----:|:----:|
| Scorable series has the most valid doses | +1 | - | -1 |
| Scorable series is a product series and has all valid doses  | +1 | - | -1 |
| Scorable series is earliest to complete | +2 | +1 | -1 |

```
  scoreAllCompletedPatientSeries() {
    singleSeries.forEach((series) {
      series.prepareToScoreSeries();
      getHighestNumValidDoses(series);
      getNumProdValidSeries(series);
      getEarliestFinishDate(series);
    });

    singleSeries.forEach((series) {
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
    singleSeries.forEach((series) {
      series.notProdValidSeries(-1);
      series.notHighestNumValidDoses(highestNumValidDoses, -1);
      series.notEarliestToFinish(earliestFinishDate, -1);
    });
  }
```

## 6.5 In-Process Patient Series

| Conditions | True for only 1 scorable series | True for >= 2 scorable series | Not true for scorable series |
|------------|:-----:|:-----:|:----:|
| Scorable series is a product series and has all valid doses | +2 | - | -2 |
| Scorable series is completeable  | +3 | - | -3 |
| Scorable series has the most valid doses | +2 | - | -2 |
| Scorable series is closest to completion | +2 | - | -2 |
| Scorable series can finish earliest | +1 | - | -1 |

```
  scoreInProcessPatientSeries() {
    singleSeries.forEach((series) {
      series.prepareToScoreSeries();
      getNumProdValidSeries(series);
      getHighestNumValidDoses(series);
      getEarliestFinishDate(series);
      getNumCompletableSeries(series);
      getLowestNumDosesFromCompletion(series);
    });
    singleSeries.forEach((series) {
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
    singleSeries.forEach((series) {
      series.notProdValidSeries(-2);
      series.notCompletable(-3);
      series.notHighestNumValidDoses(highestNumValidDoses, -2);
      series.notClosestToCompletion(lowestNumDosesFromCompletion, -2);
      series.notEarliestToFinish(earliestFinishDate, -1);
    });
  }
```

## 6.6 No Valid Doses

| Conditions | True for only 1 scorable series | True for >= 2 scorable series | Not true for scorable series |
|------------|:-----:|:-----:|:----:|
| Scorable series can start earliest | +1 | - | -1 |
| Scorable series is completeable  | +1 | - | -1 |
| Scorable series is product patient series | -1 | - | +1 |

```
  scoreNoValidDoses() {
    singleSeries.forEach((series) {
      series.prepareToScoreSeries();
      getEarliestStartDate(series);
      getNumCompletableSeries(series);
      getNumProdSeries(series);
    });
    singleSeries.forEach((series) {
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
    singleSeries.forEach((series) {
      series.notEarliestToStart(earliestFinishDate, -1);
      series.notCompletable(-1);
      series.notProdSeries(1);
    });
  }
```

## 6.7 Select Prioritized patient Series

This one is easy, the series with the highest score wins. 
