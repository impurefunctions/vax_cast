import 'package:vax_cast/src/9_shared/shared.dart';

part 'b_skippable.dart';

class VaxSeries {
  VaxPatient patient;
  List<Dose> pastDoses;
  String seriesStatus;
  //aged out, complete, contraindicated, immune, not complete, not recommended
  List<SeriesDose> seriesDose;
  int targetDose;
  String seriesName;
  String targetDisease;
  String seriesVaccineGroup;
  String seriesAdminGuidance;
  bool isStandardSeries;
  bool isDefaultSeries;
  bool isProductSeries;
  String seriesPriority;
  String seriesPreference;
  String minAgeToStart;
  String maxAgeToStart;
  List<TargetStatus> targetDoses;
  String forecastReason;
  bool prioritized;
  bool scorableSeries;
  bool shouldBeScored;
  bool allDosesValid;
  bool completeable;
  VaxDate forecastFinishDate;
  int score;
  bool bestSeries;
  RecommendedDose recommendedDose;

  VaxSeries(Series series, VaxPatient newPatient) {
    patient = newPatient;
    pastDoses = <Dose>[];
    seriesStatus = 'not complete';
    seriesDose = series.seriesDose;
    targetDose = 0;
    seriesName = series.seriesName;
    targetDisease = series.targetDisease;
    seriesVaccineGroup = series.seriesVaccineGroup;
    seriesAdminGuidance = series.seriesAdminGuidance;
    isStandardSeries = series.seriesType == 'Standard';
    isDefaultSeries = series.defaultSeries == 'Yes';
    isProductSeries = series.productPath == 'Yes';
    seriesPriority = series.seriesPriority;
    seriesPreference = series.seriesPreference;
    minAgeToStart = series.minAgeToStart;
    maxAgeToStart = series.maxAgeToStart;
    targetDoses = series.seriesDose == null
        ? null
        : List.filled(series.seriesDose.length, TargetStatus.not_satisfied);
    prioritized = false;
    scorableSeries = false;
    shouldBeScored = false;
    allDosesValid = false;
    completeable = true;
    forecastFinishDate = VaxDate.max();
    score = 0;
    bestSeries = false;
    recommendedDose;
  }

//****************************************** */
//   Evaluation Section
//****************************************** */
  void evaluateVaccineDosesAdministered(bool anySeriesComplete) {
    if (pastDoses != null && pastDoses.isNotEmpty) {
      pastDoses.sort((a, b) => a.dateGiven.compareTo(b.dateGiven));
      for (final dose in pastDoses) {
        dose.patient = patient;
        if (seriesStatus == 'not complete') {
          if (dose.canBeEvaluated()) {
            findNonSkippableTargetDose(dose, 'Evaluation', anySeriesComplete);
            if (seriesStatus == 'not complete') {
              dose.evaluatePastDose(
                  seriesDose[targetDose], targetDose, pastDoses);
              if (dose.valid() && seriesStatus == 'not complete') {
                completeTargetDose(dose.target.value2, dose.dateGiven);
              }
            }
          } else {
            dose.isSubStandard();
          }
        }
      }
    }
  }

  void findNonSkippableTargetDose(
      Dose dose, String context, bool anySeriesComplete) {
    var skip = true;
    while (skip) {
      var refDate = dose?.dateGiven ?? patient.assessmentDate;
      skip = Skippable(refDate, anySeriesComplete, patient, pastDoses)
          .checkSkipDate(seriesDose[targetDose], context);
      if (skip) {
        if (dose != null) {
          dose.skipDose();
        }
        completeTargetDose(TargetStatus.skipped, null);
        skip = seriesStatus == 'not complete';
      }
    }
  }

  void completeTargetDose(TargetStatus status, VaxDate dateGiven) {
    targetDose += 1;
    if (targetDose == seriesDose.length &&
        seriesDose.last.recurringDose == 'Yes') {
      if (seriesDose.last.seasonalRecommendation == null) {
        targetDose -= 1;
      } else if (status == TargetStatus.skipped) {
        seriesStatus = 'complete';
        targetDoses[targetDose - 1] = status;
      } else if (VaxDate.max().fromNullableString(
                  seriesDose.last.seasonalRecommendation.endDate) >
              dateGiven &&
          dateGiven >=
              VaxDate.min().fromNullableString(
                  seriesDose.last.seasonalRecommendation.startDate)) {
        seriesStatus = 'complete';
        targetDoses[targetDose - 1] = status;
      } else {
        targetDose -= 1;
      }
    } else {
      if (seriesDose[targetDose - 1].seasonalRecommendation != null) {
        if (status == TargetStatus.satisfied) {
          targetDose -= 1;
        } else {
          targetDoses[targetDose - 1] = status;
        }
      } else {
        if (targetDose == seriesDose.length) seriesStatus = 'complete';
        targetDoses[targetDose - 1] = status;
      }
    }
  }

//****************************************************************************/
//    Forecast Section
//****************************************************************************/
  void checkForSkippable(bool anySeriesComplete) {
    if (seriesStatus == 'not complete') {
      findNonSkippableTargetDose(null, 'Forecast', anySeriesComplete);
    }
  }

  void checkContraindication() {
    if (seriesStatus != 'contraindicated') {
      if (patient.conditions != null &&
          SupportingData.antigenSupportingData[targetDisease].contraindications
                  .vaccine !=
              null) {
        for (final condition in patient.conditions) {
          var obsCondition = SupportingData.antigenSupportingData[targetDisease]
              .contraindications.vaccine[condition];
          if (obsCondition != null) {
            var dob = patient.dob;
            var assessmentDate = patient.assessmentDate;
            if (dob.minIfNull(obsCondition.beginAge) <= assessmentDate &&
                assessmentDate < dob.maxIfNull(obsCondition.endAge)) {
              var contraindicatedCvx = <String>[];
              obsCondition.contraindicatedVaccine
                  .forEach((vaccine) => contraindicatedCvx.add(vaccine.cvx));
              seriesDose[targetDose]
                  .preferableVaccine
                  .removeWhere((vax) => contraindicatedCvx.contains(vax.cvx));
            }
          }
        }
      }
      if (seriesDose[targetDose].preferableVaccine.isEmpty) {
        seriesStatus = 'contraindicated';
      }
    }
  }

  bool shouldReceiveAnotherTargetDose(
      bool immunity, bool antigenContraindicated) {
    var dob = patient.dob;
    var needsAnotherDose = false;
    if (!targetDoses.contains(TargetStatus.not_satisfied)) {
      if (targetDoses.contains(TargetStatus.satisfied)) {
        needsAnotherDose = false;
        seriesStatus = 'complete';
        forecastReason = 'patient series is complete.';
      } else {
        needsAnotherDose = false;
        seriesStatus = 'not recommended';
        forecastReason =
            'not recommended at this time due to past immunization history.';
      }
    } else if (seriesStatus == 'immune' || immunity) {
      needsAnotherDose = false;
      forecastReason = 'patient has evidence of immunity';
    } else if (seriesStatus == 'contraindicated' || antigenContraindicated) {
      needsAnotherDose = false;
      seriesStatus = 'contraindicated';
      forecastReason = 'patient has a contraindication';
    } else if (patient.assessmentDate >=
        dob.maxIfNull(seriesDose[targetDose].age[0].maxAge)) {
      needsAnotherDose = false;
      seriesStatus = 'aged out';
      forecastReason = 'patient has exceeded the maximum age.';
    } else if (seriesDose[targetDose].seasonalRecommendation == null) {
      needsAnotherDose = true;
      seriesStatus = 'not complete';
    } else if (patient.assessmentDate >
        VaxDate.mmddyyyy(
            seriesDose[targetDose].seasonalRecommendation.endDate)) {
      needsAnotherDose = false;
      seriesStatus = 'not complete';
      forecastReason = 'past seasonal recommendation end date.';
    } else {
      needsAnotherDose = true;
      seriesStatus = 'not complete';
    }
    return needsAnotherDose;
  }

  void generateForecastDates(bool anySeriesComplete) {
    var forecast = true;
    while (seriesStatus == 'not complete' && forecast) {
      recommendedDose = RecommendedDose();
      recommendedDose.generateForecastDates(
          seriesDose[targetDose], patient, pastDoses);
      if (Skippable(recommendedDose.earliestDate, anySeriesComplete, patient,
              pastDoses)
          .checkSkipDate(seriesDose[targetDose], 'Forecast')) {
        completeTargetDose(TargetStatus.skipped, null);
      } else {
        forecast = false;
      }
    }
    validateForecastedDates();
  }

  void validateForecastedDates() {
    if (recommendedDose.earliestDate != null &&
        recommendedDose.latestDate != null) {
      if (recommendedDose.earliestDate >= recommendedDose.latestDate) {
        seriesStatus = 'aged out';
        forecastReason =
            'Patient is unable to finish the series prior to the maximum age';
        recommendedDose.invalidate();
      }
    }
  }

//***************************************************************************/
//   Selection Section
//***************************************************************************/
  void preFilterPatientSeries(String highPriority) {
    var assessmentDate = patient.assessmentDate;
    var dob = patient.dob;

    bool highEnoughPriority() => seriesPriority.compareTo(highPriority) != 1;

    bool isOldEnough() =>
        dob.minIfNull(minAgeToStart) <= assessmentDate ||
        seriesStatus == 'complete';

    bool startedOnTime() {
      if (pastDoses.isEmpty) return true;
      var dose = pastDoses.indexWhere((dose) => dose.valid());
      return dose == -1
          ? true
          : pastDoses[dose].dateGiven < dob.maxIfNull(maxAgeToStart);
    }

    if (highEnoughPriority() && isOldEnough() && startedOnTime()) {
      scorableSeries = true;
    } else {
      scorableSeries = false;
    }
  }

  void prepareToScoreSeries() {
    var dob = patient.dob;
    allDosesValid = pastDoses.indexWhere((dose) => !dose.valid()) == -1;
    if (seriesStatus == 'complete') {
      forecastFinishDate = VaxDate.min();
    } else {
      forecastFinishDate = recommendedDose.earliestDate;
      for (var i = targetDose + 1; i < seriesDose.length; i++) {
        if (seriesDose[i].interval != null) {
          if (seriesDose[i].interval[0].fromPrevious == 'Y') {
            forecastFinishDate =
                forecastFinishDate.change(seriesDose[i].interval[0].absMinInt);
          }
        }
        forecastFinishDate = forecastFinishDate >
                dob.minIfNull(seriesDoseAge(seriesDose[i]).absMinAge)
            ? forecastFinishDate
            : dob.minIfNull(seriesDoseAge(seriesDose[i]).absMinAge);
      }
    }
    completeable = forecastFinishDate <
        dob.maxIfNull(seriesDoseAge(seriesDose.last).maxAge);
  }

  VaxAge seriesDoseAge(SeriesDose seriesDose) => seriesDose.age.length == 1
      ? seriesDose.age[0]
      : VaxDate.mmddyyyy(seriesDose.age[0].cessationDate) >=
              patient.assessmentDate
          ? seriesDose.age[0]
          : seriesDose.age[1];

  void notProdValidSeries(int points) =>
      score += isProductSeries && allDosesValid ? 0 : points;

  void notProdSeries(int points) => score += isProductSeries ? 0 : points;

  void notCompletable(int points) => score += completeable ? 0 : points;

  void notHighestNumValidDoses(int highestNumValidDoses, int points) =>
      score += targetDose == highestNumValidDoses ? 0 : points;

  void notClosestToCompletion(int lowestNumDosesFromCompletion, int points) =>
      score +=
          seriesDose.length - targetDose + 1 == lowestNumDosesFromCompletion
              ? 0
              : points;

  void notEarliestToFinish(VaxDate earliestFinishDate, int points) =>
      score += forecastFinishDate == earliestFinishDate ? 0 : points;

  void notEarliestToStart(VaxDate earliestFinishDate, int points) =>
      score += recommendedDose.earliestDate == earliestFinishDate ? 0 : points;

//***************************************************************************/
//   Checks for Best Series
//***************************************************************************/
  void isItABestSeries(List<Group> groups, String equivalentGroups) {
    if (seriesStatus == 'complete' || equivalentGroups == null) {
      bestSeries = true;
    } else {
      var equivalentIndex =
          groups.indexWhere((group) => group.seriesGroup == equivalentGroups);
      if (equivalentIndex == -1) {
        bestSeries = true;
      } else if (groups[equivalentIndex].vaxSeries[0].seriesStatus ==
          'complete') {
        bestSeries = false;
      } else if (!isStandardSeries) {
        bestSeries = true;
      } else if (!groups[equivalentIndex].vaxSeries[0].isStandardSeries) {
        bestSeries = false;
      } else {
        bestSeries = true;
      }
    }
  }

//***************************************************************************/
//   Checks for Skippable
//***************************************************************************/
}
