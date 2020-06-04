// part of 'a_group.dart';

// abstract class Scoring {
//   static int getHighestNumValidDoses(VaxSeries series, highestNumValidDoses) {
//     var count = 0;
//     series.targetDoses.forEach((dose) => count += dose == 'valid' ? 1 : 0);
//     return highestNumValidDoses >= count ? highestNumValidDoses : count;
//   }

//   static int getNumSeriesWithHighestNumValidDoses(
//     VaxSeries series,
//     int numSeriesWithHighestNumValidDoses,
//     int highestNumValidDoses,
//   ) =>
//       numSeriesWithHighestNumValidDoses +=
//           series.targetDose == highestNumValidDoses ? 1 : 0;

//   static List<VaxSeries> awardNumSeriesWithHighestNumValidDoses(
//     int points,
//     List<VaxSeries> vaxSeries,
//     int highestNumValidDoses,
//   ) {
//     vaxSeries
//         .firstWhere((series) => series.targetDose == highestNumValidDoses)
//         .score += points;
//     return vaxSeries;
//   }

//   static VaxDate getEarliestFinishDate(
//           VaxSeries series, VaxDate earliestFinishDate) =>
//       earliestFinishDate <= series.recommendedDose.earliestDate
//           ? earliestFinishDate
//           : series.recommendedDose.earliestDate;

//   static int getNumSeriesFinishingEarliest(
//     VaxSeries series,
//     int numSeriesFinishingEarliest,
//     VaxDate earliestFinishDate,
//   ) =>
//       numSeriesFinishingEarliest +=
//           series.forecastFinishDate == earliestFinishDate ? 1 : 0;

//   static List<VaxSeries> awardNumSeriesFinishingEarliest(
//     int points,
//     List<VaxSeries> vaxSeries,
//     VaxDate earliestFinishDate,
//   ) {
//     vaxSeries
//         .firstWhere((series) => series.forecastFinishDate == earliestFinishDate)
//         .score += points;
//     return vaxSeries;
//   }

//   static VaxDate getEarliestStartDate(
//           VaxSeries series, VaxDate earliestStartDate) =>
//       earliestStartDate <= series.recommendedDose.earliestDate
//           ? earliestStartDate
//           : series.recommendedDose.earliestDate;

//   static int getNumSeriesStartingEarliest(
//     VaxSeries series,
//     int numSeriesStartingEarliest,
//     VaxDate earliestStartDate,
//   ) =>
//       numSeriesStartingEarliest +=
//           series.forecastFinishDate == earliestStartDate ? 1 : 0;

//   static List<VaxSeries> awardNumSeriesStartingEarliest(
//     int points,
//     List<VaxSeries> vaxSeries,
//     VaxDate earliestStartDate,
//   ) {
//     vaxSeries
//         .firstWhere((series) =>
//             series.recommendedDose.earliestDate == earliestStartDate)
//         .score += points;
//     return vaxSeries;
//   }

//   static int getLowestNumDosesFromCompletion(
//     VaxSeries series,
//     int lowestNumDosesFromCompletion,
//   ) =>
//       lowestNumDosesFromCompletion <=
//               (series.seriesDose.length - series.targetDose + 1)
//           ? lowestNumDosesFromCompletion
//           : series.seriesDose.length - series.targetDose + 1;

//   static int getNumSeriesClosestToCompletion(
//     VaxSeries series,
//     int numSeriesClosestToCompletion,
//     int lowestNumDosesFromCompletion,
//   ) =>
//       numSeriesClosestToCompletion +=
//           series.seriesDose.length - series.targetDose + 1 ==
//                   lowestNumDosesFromCompletion
//               ? 1
//               : 0;

//   static List<VaxSeries> awardNumSeriesClosestToCompletion(
//     int points,
//     List<VaxSeries> vaxSeries,
//     int lowestNumDosesFromCompletion,
//   ) {
//     vaxSeries
//         .firstWhere((series) =>
//             series.seriesDose.length - series.targetDose + 1 ==
//             lowestNumDosesFromCompletion)
//         .score += points;
//     return vaxSeries;
//   }

//   static int getNumProdSeries(VaxSeries series, int numProdSeries) =>
//       numProdSeries += series.isProductSeries ? 1 : 0;

//   static List<VaxSeries> awardNumProdSeries(
//       int points, List<VaxSeries> vaxSeries) {
//     vaxSeries.firstWhere((series) => series.isProductSeries).score += points;
//     return vaxSeries;
//   }

//   static int getNumProdValidSeries(VaxSeries series, int numProdValidSeries) =>
//       numProdValidSeries +=
//           series.isProductSeries && series.allDosesValid ? 1 : 0;

//   static List<VaxSeries> awardNumProdValidSeries(
//       int points, List<VaxSeries> vaxSeries) {
//     vaxSeries
//         .firstWhere((series) => series.isProductSeries && series.allDosesValid)
//         .score += points;
//     return vaxSeries;
//   }

//   static int getNumCompletableSeries(
//     VaxSeries series,
//     int numCompletableSeries,
//   ) =>
//       numCompletableSeries += series.completable ? 1 : 0;

//   static List<VaxSeries> awardNumCompletableSeries(
//       int points, List<VaxSeries> vaxSeries) {
//     vaxSeries.firstWhere((series) => series.completable).score += points;
//     return vaxSeries;
//   }

//   static int notProdValidSeries(
//           int points, int score, bool isProductSeries, bool allDosesValid) =>
//       score += isProductSeries && allDosesValid ? 0 : points;

//   static int notProdSeries(int points, int score, bool isProductSeries) =>
//       score += isProductSeries ? 0 : points;

//   static int notCompletable(int points, int score, bool completable) =>
//       score += completable ? 0 : points;

//   static int notHighestNumValidDoses(
//           int highestNumValidDoses, int points, int score, int targetDose) =>
//       score += targetDose == highestNumValidDoses ? 0 : points;

//   static int notClosestToCompletion(int lowestNumDosesFromCompletion,
//           int points, int score, int seriesDoseLength, targetDose) =>
//       score += seriesDoseLength - targetDose + 1 == lowestNumDosesFromCompletion
//           ? 0
//           : points;

//   static int notEarliestToFinish(VaxDate earliestFinishDate, int points,
//           int score, VaxDate forecastFinishDate) =>
//       score += forecastFinishDate == earliestFinishDate ? 0 : points;

//   static int notEarliestToStart(VaxDate earliestStartDate, int points,
//           int score, VaxDate earliestDate) =>
//       score += earliestDate == earliestStartDate ? 0 : points;
// }
