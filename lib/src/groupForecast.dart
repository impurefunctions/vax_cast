// import 'package:vax_cast/src/shared.dart';

// class GroupForecast {
//   List<String> seriesName;
//   List<String> targetDisease;
//   String seriesVaccineGroup;
//   String groupStatus;
//   VaxDate groupEarliestDate;
//   VaxDate groupAdjRecDate;
//   VaxDate groupAdjPastDueDate;
//   VaxDate groupLatestDate;
//   VaxDate groupUnadjRecDate;
//   VaxDate groupUnadjPastDueDate;
//   String groupForecastReason;
//   List<String> groupForecastAgNeeded;
//   List<Vaccine> groupRecVaccines;
//   List<RecommendedDose> recommendedDoses;
//   String intervalPriority;

//   GroupForecast({
//     seriesName,
//     targetDisease,
//     this.seriesVaccineGroup,
//     this.groupStatus,
//     this.groupEarliestDate,
//     this.groupAdjRecDate,
//     this.groupAdjPastDueDate,
//     this.groupLatestDate,
//     this.groupUnadjRecDate,
//     this.groupUnadjPastDueDate,
//     groupForecastReason,
//     groupForecastAgNeeded,
//     groupRecVaccines,
//     recommendedDoses,
//     this.intervalPriority,
//   }) {
//     this.seriesName = <String>[];
//     this.targetDisease = <String>[];
//     this.groupForecastAgNeeded = <String>[];
//     this.groupRecVaccines = <Vaccine>[];
//     this.groupForecastReason = '';
//     this.recommendedDoses = <RecommendedDose>[];
//   }

//   GroupForecast.singleAg(bestSeries) {
//     seriesName = [bestSeries.seriesName];
//     targetDisease = [bestSeries.targetDisease];
//     groupStatus = bestSeries.seriesStatus;
//     if (bestSeries.recommendedDose != null) {
//       groupEarliestDate = bestSeries.recommendedDose.earliestDate;
//       groupAdjRecDate = bestSeries.recommendedDose.adjustedRecommendedDate;
//       groupAdjPastDueDate = bestSeries.recommendedDose.adjustedPastDueDate;
//       groupLatestDate = bestSeries.recommendedDose.latestDate;
//       groupUnadjRecDate = bestSeries.recommendedDose.unadjustedRecommendedDate;
//       groupUnadjPastDueDate = bestSeries.recommendedDose.unadjustedPastDueDate;
//       recommendedDoses = [bestSeries.recommendedDose];
//       intervalPriority = bestSeries.recommendedDose.intervalPriority;
//     }
//     groupForecastReason = bestSeries.forecastReason;
//     groupRecVaccines = bestSeries.seriesStatus == 'not complete'
//         ? bestSeries.seriesDose[bestSeries.targetDose].preferableVaccine
//         : null;
//     seriesVaccineGroup = bestSeries.seriesVaccineGroup;
//   }

//   void finalDates() {
//     groupAdjRecDate = LatestOf([groupAdjRecDate, groupEarliestDate]);
//     groupAdjPastDueDate = LatestOf([groupAdjPastDueDate, groupEarliestDate]);
//   }

//   void applyMultiAgLogic(VaxSeries series) {
//     if (series.seriesStatus == 'not complete') {
//       _selectDates(series.recommendedDose);
//       _addToReasons(series.forecastReason.toString(), series.targetDisease);
//       _addToAntigens(series.seriesStatus.toString(), series.targetDisease);
//       _addRecommendedVaccines(
//           series.seriesDose[series.targetDose].preferableVaccine);
//       recommendedDoses.add(series.recommendedDose);
//       seriesName.add(series.seriesName);
//       targetDisease.add(series.targetDisease);
//     }
//   }

//   void _addRecommendedVaccines(List<Vaccine> preferred) {
//     preferred.forEach((vaccine) => groupRecVaccines.add(vaccine));
//   }

//   void _addToAntigens(String status, String disease) {
//     if (status == 'not complete') {
//       groupForecastAgNeeded.add(disease);
//     }
//   }

//   void _addToReasons(String forecastReason, String disease) {
//     groupForecastReason += '$disease: $forecastReason\n';
//   }

//   void _selectDates(RecommendedDose recommendedDose) {
//     if (recommendedDose.intervalPriority == 'override' ||
//         intervalPriority == 'override') {
//       groupEarliestDate =
//           EarliestOf([groupEarliestDate, recommendedDose.earliestDate]);
//       intervalPriority = 'override';
//     } else {
//       groupEarliestDate =
//           LatestOf([groupEarliestDate, recommendedDose.earliestDate]);
//     }
//     groupAdjRecDate =
//         EarliestOf([groupAdjRecDate, recommendedDose.adjustedRecommendedDate]);
//     groupAdjPastDueDate =
//         EarliestOf([groupAdjPastDueDate, recommendedDose.adjustedPastDueDate]);
//     groupLatestDate = EarliestOf([groupLatestDate, recommendedDose.latestDate]);
//     groupUnadjRecDate = EarliestOf(
//         [groupUnadjRecDate, recommendedDose.unadjustedRecommendedDate]);
//     groupUnadjPastDueDate = EarliestOf(
//         [groupUnadjPastDueDate, recommendedDose.unadjustedPastDueDate]);
//   }

//   void convertNull() {
//     groupEarliestDate ??= VaxDate.max();
//     groupAdjRecDate ??= VaxDate.max();
//     groupAdjPastDueDate ??= VaxDate.max();
//     groupLatestDate ??= VaxDate.max();
//     groupUnadjRecDate ??= VaxDate.max();
//     groupUnadjPastDueDate ??= VaxDate.max();
//   }
// }
