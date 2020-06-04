import 'package:vax_cast/src/shared.dart';

class VaxSeries {
  Series series;

  VaxSeries();
}
//   VaxPatient patient;
//   List<Dose> pastDoses;
//   SeriesStatus seriesStatus;

//   int targetDose;
//   String seriesName;
//   String targetDisease;
//   String seriesVaccineGroup;
//   String seriesAdminGuidance;
//   bool isStandardSeries;
//   bool isDefaultSeries;
//   bool isProductSeries;
//   String seriesPriority;
//   String seriesPreference;
//   String minAgeToStart;
//   String maxAgeToStart;
//   List<TargetStatus> targetDoses;
//   ForecastReason forecastReason;
//   bool prioritized;
//   bool scorableSeries;
//   bool shouldBeScored;
//   bool allDosesValid;
//   bool completable;
//   VaxDate forecastFinishDate;
//   int score;
//   bool bestSeries;
//   RecommendedDose recommendedDose;
//   bool anotherDose;

//   VaxSeries(Series series, VaxPatient newPatient) {
//     patient = newPatient;
//     pastDoses = <Dose>[];

//     prioritized = false;
//     scorableSeries = false;
//     shouldBeScored = false;
//     allDosesValid = false;
//     completable = true;
//     forecastFinishDate = VaxDate.max();
//     score = 0;
//     bestSeries = false;
//     recommendedDose;
//   }

//   void evaluateVaccineDosesAdministered(bool anySeriesComplete) {
//     if (pastDoses != null && pastDoses.isNotEmpty) {
//       pastDoses.sort((a, b) => a.dateGiven.compareTo(b.dateGiven));
//       for (final dose in pastDoses) {
//         dose.patient = patient;
//         if (seriesStatus == SeriesStatus.not_complete) {
//           dose.evaluateDoseCondition();
//           checkForSkippableDose(dose.valid, dose.dateGiven, Context.evaluation,
//               anySeriesComplete);
//           if (seriesStatus == SeriesStatus.not_complete) {
//             dose.evaluatePastDose(
//                 seriesDose[targetDose], pastDoses, targetDose);
//             if (dose.valid && seriesStatus == SeriesStatus.not_complete) {
//               completeTargetDose(dose.target.value2, dose.dateGiven);
//             }
//           }
//         }
//       }
//     }
//   }

//   void checkForSkippableDose(
//       bool valid, VaxDate date, Context context, bool anySeriesComplete) {
//     if (valid) {
//       Skippable skippable = Skippable(
//         date ?? patient.assessmentDate,
//         context,
//         anySeriesComplete,
//         patient,
//         pastDoses,
//       );
//       while (skippable.checkForSkip(seriesDose[targetDose]) &&
//           seriesStatus == SeriesStatus.not_complete) {
//         completeTargetDose(
//             TargetStatus.skipped, date ?? patient.assessmentDate);
//       }
//     }
//   }

//   void completeTargetDose(TargetStatus status, VaxDate dateGiven) {
//     CompleteTargetDose complete = CompleteTargetDose(
//       status,
//       dateGiven,
//       this.targetDose,
//       this.seriesDose,
//       this.seriesStatus,
//       this.targetDoses,
//     );
//     complete.completeTargetDose();
//     targetDose = complete.targetDose;
//     seriesStatus = complete.seriesStatus;
//     targetDoses = complete.targetDoses;
//   }

//   void checkForSkippable(bool anySeriesComplete) {
//     if (seriesStatus == SeriesStatus.not_complete) {
//       checkForSkippableDose(true, null, Context.forecast, anySeriesComplete);
//     }
//   }

//   void checkContraindication() {
//     if (ContraindicatedSeries.check(
//       seriesStatus,
//       patient,
//       targetDisease,
//       seriesDose[targetDose],
//     )) {
//       seriesStatus = SeriesStatus.contraindicated;
//     }
//   }

//   void shouldReceiveAnotherTargetDose(
//       bool immunity, bool antigenContraindicated) {
//     AnotherTargetDose another = AnotherTargetDose(
//       seriesDose[targetDose],
//       patient,
//       seriesStatus,
//     );
//     another.evaluateAnotherDose(targetDoses, immunity, antigenContraindicated);
//     anotherDose = another.anotherDose;
//     seriesStatus = another.status;
//     forecastReason = another.forecastReason;
//   }

//   void generateForecastDates(bool anySeriesComplete) {
//     var forecast = true;
//     while (seriesStatus == SeriesStatus.not_complete && forecast) {
//       recommendedDose = RecommendedDose();
//       recommendedDose.generateForecastDates(
//           seriesDose[targetDose], patient, pastDoses);
//       int oldTarget = targetDose;
//       checkForSkippableDose(
//         true,
//         recommendedDose.earliestDate,
//         Context.forecast,
//         anySeriesComplete,
//       );
//       forecast = oldTarget != targetDose;
//     }
//     if (recommendedDose.earliestDate != null &&
//         recommendedDose.latestDate != null) {
//       if (recommendedDose.earliestDate >= recommendedDose.latestDate) {
//         seriesStatus = SeriesStatus.aged_out;
//         forecastReason = ForecastReason.exceeded_maximum_age;
//         recommendedDose.invalidate();
//       }
//     }
//   }

//   void preFilterSeries(String highPriority) =>
//       scorableSeries = PreFilter.scorable(this, highPriority);

//   void prepareToScoreSeries() {
//     PrepareSeries prepare = PrepareSeries();
//     prepare.toScore(this);
//     allDosesValid = prepare.allDosesValid;
//     forecastFinishDate = prepare.forecastFinishDate;
//     completable = prepare.completable;
//   }

// //***************************************************************************/
// //   Checks for Best Series
// //***************************************************************************/
//   void isItABestSeries(List<Group> groups, String equivalentGroups) {
//     if (seriesStatus == 'complete' || equivalentGroups == null) {
//       bestSeries = true;
//     } else {
//       var equivalentIndex =
//           groups.indexWhere((group) => group.seriesGroup == equivalentGroups);
//       if (equivalentIndex == -1) {
//         bestSeries = true;
//       } else if (groups[equivalentIndex].vaxSeries[0].seriesStatus ==
//           'complete') {
//         bestSeries = false;
//       } else if (!isStandardSeries) {
//         bestSeries = true;
//       } else if (!groups[equivalentIndex].vaxSeries[0].isStandardSeries) {
//         bestSeries = false;
//       } else {
//         bestSeries = true;
//       }
//     }
//   }

// //***************************************************************************/
// //   Checks for Skippable
// //***************************************************************************/
//   bool IsSkippable(
//       ConditionalSkip skip, VaxDate refDate, bool anySeriesComplete) {
//     for (final vaxSet in skip.vaxSet) {
//       if (shouldBeSkipped(vaxSet, refDate, anySeriesComplete)) return true;
//     }
//     return false;
//   }

//   bool shouldBeSkipped(
//           VaxSet vaxSet, VaxDate refDate, bool anySeriesComplete) =>
//       canUseOrLogic(vaxSet.conditionLogic)
//           ? orCondition(vaxSet, refDate, anySeriesComplete)
//           : andCondition(vaxSet, refDate, anySeriesComplete);

//   bool canUseOrLogic(String logic) => (logic == null || logic == 'OR');

//   bool orCondition(VaxSet vaxSet, VaxDate refDate, bool anySeriesComplete) {
//     for (final condition in vaxSet.condition) {
//       if (isSkipConditionMet(condition, refDate, anySeriesComplete)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   bool andCondition(VaxSet vaxSet, VaxDate refDate, bool anySeriesComplete) {
//     for (final condition in vaxSet.condition) {
//       if (!isSkipConditionMet(condition, refDate, anySeriesComplete)) {
//         return false;
//       }
//     }
//     return true;
//   }

//   bool isSkipConditionMet(
//       Condition condition, VaxDate refDate, bool anySeriesComplete) {
//     switch (condition.conditionType) {
//       case 'Age':
//         {
//           return ageCondition(condition, refDate);
//         }
//         break;
//       case 'Completed Series':
//         {
//           return anySeriesComplete;
//         }
//         break;
//       case 'Interval':
//         {
//           return intervalCondition(condition, refDate);
//         }
//         break;
//       case 'Vaccine Count by Age':
//         {
//           return countCondition(condition, refDate);
//         }
//         break;
//       case 'Vaccine Count by Date':
//         {
//           return countCondition(condition, refDate);
//         }
//         break;
//     }
//     return false;
//   }

//   bool ageCondition(Condition condition, VaxDate refDate) =>
//       patient.dob.minIfNull(condition.beginAge) <= refDate &&
//       refDate < patient.dob.maxIfNull(condition.endAge);

//   bool intervalCondition(Condition condition, VaxDate refDate) {
//     if (pastDoses.isEmpty) return false;
//     var date = VaxDate.min();
//     pastDoses.forEach((dose) {
//       if (dose.dateGiven < refDate && dose.dateGiven > date) {
//         date = dose.dateGiven;
//       }
//     });
//     return date == VaxDate.min()
//         ? false
//         : refDate >= date.change(condition.interval);
//   }

//   bool countCondition(Condition condition, VaxDate refDate) {
//     if (pastDoses.isEmpty) return false;
//     var count = 0;
//     var doses = <Dose>[];
//     pastDoses.forEach((dose) {
//       if (dose.dateGiven <= refDate) doses.add(dose);
//     });
//     for (var i = 0; i < doses.length; i++) {
//       var addToCount = true;
//       if (condition.conditionType == 'Vaccine Count by Age') {
//         addToCount = addToCountByAge(condition, doses.elementAt(i));
//       } else if (condition.conditionType == 'Vaccine Count by Date') {
//         addToCount = addToCountByDate(condition, doses.elementAt(i));
//       }
//       if (condition.vaccineTypes != null) {
//         addToCount &= addToCountByType(condition, doses.elementAt(i));
//       }
//       if (condition.doseType == 'Valid') {
//         addToCount &= pastDoses[i].valid;
//       }

//       count += addToCount ? 1 : 0;
//     }
//     return condition.doseCountLogic == 'greater than'
//         ? count > int.parse(condition.doseCount)
//         : condition.doseCountLogic == 'equal to'
//             ? count == int.parse(condition.doseCount)
//             : count < int.parse(condition.doseCount);
//   }

//   bool addToCountByAge(Condition condition, Dose dose) =>
//       patient.dob.maxIfNull(condition.endAge) > dose.dateGiven &&
//       dose.dateGiven >= patient.dob.minIfNull(condition.beginAge);

//   bool addToCountByDate(Condition condition, Dose dose) =>
//       VaxDate.min().fromNullableString(condition.startDate) <= dose.dateGiven &&
//       dose.dateGiven < VaxDate.max().fromNullableString(condition.endDate);

//   bool addToCountByType(Condition condition, Dose dose) =>
//       condition.vaccineTypes.contains(dose.cvx);
// }
