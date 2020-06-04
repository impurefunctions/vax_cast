// part of 'a_group.dart';

// abstract class Prioritized {
//   static int findOne(
//     int defaultSeries,
//     Scorable scorable,
//     List<VaxSeries> vaxSeries,
//   ) =>
//       scorable.numScorableSeries == 0 && defaultSeries != -1
//           ? defaultSeries
//           : scorable.numScorableSeries == 1
//               ? vaxSeries.indexWhere((series) => series.scorableSeries)
//               : scorable.numCompleteSeries == 1
//                   ? vaxSeries
//                       .indexWhere((series) => series.seriesStatus == 'complete')
//                   : scorable.numSeriesInProcess == 1
//                       ? vaxSeries.indexWhere((series) => series.targetDose != 0)
//                       : scorable.numSeriesInProcess == 0 && defaultSeries != -1
//                           ? defaultSeries
//                           : -1;
// }
