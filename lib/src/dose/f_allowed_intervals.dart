// part of 'a_dose.dart';

// abstract class AllowedIntervals {
//   static Tuple2<bool, String> checkAllowed(
//       SeriesDose seriesDose, List<Dose> pastDoses, Dose dose) {
//     Tuple2<bool, String> allowedInt;
//     if (seriesDose.allowableInterval == null) {
//       allowedInt = Tuple2(false, 'no interval specified');
//     } else if (pastDoses.indexOf(dose) == 0) {
//       allowedInt = Tuple2(true, 'first dose patient received');
//     } else {
//       var allowable = seriesDose.allowableInterval;
//       var index;
//       var compareDose;
//       if (allowable.fromPrevious == 'Y') {
//         index = pastDoses.indexOf(dose) - 1;
//         compareDose = 'previous dose';
//       } else if (allowable.fromTargetDose != null) {
//         index = pastDoses.indexWhere((dose) =>
//             dose.target.value1 == int.parse(allowable.fromTargetDose) - 1);
//         compareDose = 'dose ${allowable.fromTargetDose}';
//       }
//       allowedInt = Tuple2(
//           dose.dateGiven >=
//               pastDoses[index].dateGiven.minIfNull(allowable.absMinInt),
//           '$compareDose too soon');
//     }

//     return allowedInt;
//   }

//   static Tuple2<int, TargetStatus> getTarget() =>
//       Tuple2(-1, TargetStatus.not_satisfied);

//   static Tuple2<EvalStatus, String> getEvaluation(
//           String prefReason, String allowReason) =>
//       Tuple2(EvalStatus.not_valid, '$prefReason, $allowReason');
// }
