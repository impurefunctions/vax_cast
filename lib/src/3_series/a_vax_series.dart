import 'package:dartz/dartz.dart';
import 'package:vax_cast/src/shared.dart';

part 'b_skippable.dart';
part 'c_complete_target_dose.dart';

class VaxSeries {
  Series series;
  List<Dose> pastDoses;
  List<TargetStatus> targetDoses;
  SeriesStatus seriesStatus;

  VaxSeries(this.series) {
    targetDoses =
        List.filled(series.seriesDose.length, TargetStatus.not_satisfied);
  }

  int targetDose() => targetDoses
      .indexWhere((targetStatus) => targetStatus == TargetStatus.not_satisfied);

  void evaluateDoses(VaxPatient patient) {
    if (pastDoses != null) {
      pastDoses.forEach((dose) {
        dose.evalCondition();
        if (dose.target.value1 != -1) {
          checkForSkip(patient, Context.evaluation, dose.dateGiven);
        }
      });
    }
  }

  void checkForSkip(VaxPatient patient, Context context, VaxDate dateGiven) {
    bool skip = true;
    while (skip) {
      Skip skippable = Skip(
          series.seriesDose[targetDose()], patient, context, false, pastDoses);
      if (skippable.skipNextDose() &&
          seriesStatus == SeriesStatus.not_complete) {
        completeTargetDose(TargetStatus.skipped, dateGiven);
      }
    }
  }

  void completeTargetDose(TargetStatus status, VaxDate dateGiven) {
    Tuple2<SeriesStatus, TargetStatus> statuses;
    if (isRecurring(series.seriesDose, targetDose())) {
      statuses =
          completeRecurringDose(series.seriesDose.last, status, dateGiven);
    } else {
      statuses =
          completeNonRecurringDose(series.seriesDose, status, targetDose());
    }
    seriesStatus = statuses?.value1 ?? seriesStatus;
    targetDoses[targetDose()] = statuses.value2;
  }
}

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
