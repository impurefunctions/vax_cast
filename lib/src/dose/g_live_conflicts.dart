part of 'a_dose.dart';

abstract class LiveConflicts {
  static Tuple2<bool, Dose> hasNoLiveVirusConflict(
      VaxPatient patient, Dose thisDose) {
    if (patient.liveVirusList.isNotEmpty) {
      var liveVaccines = <Dose>[];
      patient.liveVirusList.forEach((dose) {
        if (dose.dateGiven < thisDose.dateGiven) liveVaccines.add(dose);
      });
      if (liveVaccines.isNotEmpty) {
        var liveConflicts = <LiveVirusConflict>[];
        SupportingData.scheduleSupportingData.liveVirusConflicts
            .forEach((dose) {
          if (dose.currentCvx == thisDose.cvx) liveConflicts.add(dose);
        });
        if (liveConflicts.isNotEmpty) {
          for (final conflict in liveConflicts) {
            var index = liveVaccines
                .indexWhere((dose) => dose.cvx == conflict.previousCvx);
            if (index != -1) {
              var conflictBegin =
                  thisDose.dateGiven.maxIfNull(conflict.conflictBeginInterval);
              var conflictEnd = thisDose.dateGiven.minIfNull(thisDose.valid
                  ? conflict.minConflictEndInterval
                  : conflict.conflictEndInterval);
              if (conflictBegin <= thisDose.dateGiven &&
                  thisDose.dateGiven < conflictEnd) {
                return Tuple2(true, liveVaccines[index]);
              }
            }
          }
        }
      }
    }
    return Tuple2(false, null);
  }

  static Tuple2<int, TargetStatus> getTarget() =>
      Tuple2(-1, TargetStatus.not_satisfied);

  static Tuple2<EvalStatus, String> getEvaluation() =>
      Tuple2(EvalStatus.not_valid, 'live virus conflict');
}
