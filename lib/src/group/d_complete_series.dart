// part of 'a_group.dart';

// abstract class CompleteSeries {
//   static List<VaxSeries> scoreAll(List<VaxSeries> vaxSeries) {
//     vaxSeries
//         .retainWhere((series) => series.seriesStatus == SeriesStatus.complete);
//     return scoreAllCompletedPatientSeries(vaxSeries);
//   }

//   static List<VaxSeries> scoreAllCompletedPatientSeries(
//       List<VaxSeries> vaxSeries) {
//     int highestNumValidDoses = 0;
//     int numProdValidSeries = 0;
//     VaxDate earliestFinishDate = VaxDate.max();

//     vaxSeries.forEach((series) {
//       series.prepareToScoreSeries();
//       highestNumValidDoses =
//           Scoring.getHighestNumValidDoses(series, highestNumValidDoses);
//       numProdValidSeries =
//           Scoring.getNumProdValidSeries(series, numProdValidSeries);
//       earliestFinishDate =
//           Scoring.getEarliestFinishDate(series, earliestFinishDate);
//     });

//     int numSeriesWithHighestNumValidDoses = 0;
//     int numSeriesFinishingEarliest = 0;

//     vaxSeries.forEach((series) {
//       numSeriesWithHighestNumValidDoses =
//           Scoring.getNumSeriesWithHighestNumValidDoses(
//         series,
//         numSeriesWithHighestNumValidDoses,
//         highestNumValidDoses,
//       );
//       numSeriesFinishingEarliest = Scoring.getNumSeriesFinishingEarliest(
//         series,
//         numSeriesFinishingEarliest,
//         earliestFinishDate,
//       );
//     });

//     if (numSeriesWithHighestNumValidDoses == 1) {
//       vaxSeries = Scoring.awardNumSeriesWithHighestNumValidDoses(
//         1,
//         vaxSeries,
//         highestNumValidDoses,
//       );
//     }

//     if (numProdValidSeries == 1) {
//       vaxSeries = Scoring.awardNumProdValidSeries(
//         1,
//         vaxSeries,
//       );
//     }

//     if (numSeriesFinishingEarliest == 1) {
//       vaxSeries = Scoring.awardNumSeriesFinishingEarliest(
//         2,
//         vaxSeries,
//         earliestFinishDate,
//       );
//     }

//     vaxSeries.forEach((series) {
//       series.score = Scoring.notProdValidSeries(
//         -1,
//         series.score,
//         series.isProductSeries,
//         series.allDosesValid,
//       );
//       series.score = Scoring.notHighestNumValidDoses(
//         highestNumValidDoses,
//         -1,
//         series.score,
//         series.targetDose,
//       );
//       series.score = Scoring.notEarliestToFinish(
//         earliestFinishDate,
//         -1,
//         series.score,
//         series.forecastFinishDate,
//       );
//     });

//     return vaxSeries;
//   }
// }
