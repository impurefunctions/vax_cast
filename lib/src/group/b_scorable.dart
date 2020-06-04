// part of 'a_group.dart';

// class Scorable {
//   int numScorableSeries;
//   int numSeriesInProcess;
//   int numCompleteSeries;

//   Scorable() {
//     numScorableSeries = 0;
//     numSeriesInProcess = 0;
//     numCompleteSeries = 0;
//   }

//   void getNumbers(List<VaxSeries> vaxSeries) {
//     for (final series in vaxSeries) {
//       numCompleteSeries += series.seriesStatus == 'complete' ? 1 : 0;
//       numScorableSeries +=
//           series.scorableSeries == null ? 0 : series.scorableSeries ? 1 : 0;
//       numSeriesInProcess +=
//           series.targetDose != 0 && series.seriesStatus == 'not complete'
//               ? 1
//               : 0;
//     }
//   }
// }
