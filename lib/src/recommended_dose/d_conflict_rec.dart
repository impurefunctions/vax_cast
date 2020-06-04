// part of 'a_recommended_dose.dart';

// abstract class ConflictRec {
//   static VaxDate checkForConflicts(
//       SeriesDose seriesDose, List<Dose> liveVirusList) {
//     List<String> conflictCvx = <String>[];
//     if (seriesDose.allowableVaccine != null) {
//       seriesDose.allowableVaccine.forEach((dose) {
//         if (!conflictCvx.contains(dose.cvx)) conflictCvx.add(dose.cvx);
//       });
//     }
//     if (seriesDose.preferableVaccine != null) {
//       seriesDose.preferableVaccine.forEach((dose) {
//         if (!conflictCvx.contains(dose.cvx)) conflictCvx.add(dose.cvx);
//       });
//     }
//     List<VaxDate> latestConflictEndIntDate = <VaxDate>[];
//     for (final liveDose in liveVirusList) {
//       for (final conflict
//           in SupportingData.scheduleSupportingData.liveVirusConflicts) {
//         if (conflict.previousCvx == liveDose.cvx &&
//             conflictCvx.contains(conflict.currentCvx)) {
//           latestConflictEndIntDate.add(liveDose.dateGiven
//               .changeIfNotNull(conflict.minConflictEndInterval));
//         }
//       }
//     }
//     return LatestOf(latestConflictEndIntDate);
//   }
// }
