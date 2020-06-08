part of 'a_dose.dart';

Tuple2<bool, int> evalLiveVirusConflict(
    VaxPatient patient, String cvx, VaxDate dateGiven) {
  if (patient.liveVirusList.isNotEmpty) {
    var liveVaccines = liveVirusList(patient, dateGiven);
    if (liveVaccines.isNotEmpty) {
      var liveConflicts = liveConflictList(cvx);
      if (liveConflicts.isNotEmpty) {
        for (final conflict in liveConflicts) {
          var index = liveVaccines
              .indexWhere((dose) => dose.cvx == conflict.previousCvx);
          if (index != -1) {
            if (isThereConflict(conflict, liveVaccines[index], dateGiven)) {
              return Tuple2(true, index);
            }
          }
        }
      }
    }
  }
  return Tuple2(false, -1);
}

List<Dose> liveVirusList(VaxPatient patient, VaxDate dateGiven) {
  var liveList = <Dose>[];
  patient.liveVirusList.forEach((dose) {
    if (dose.dateGiven < dateGiven) {
      liveList.add(dose);
    }
  });
  return liveList;
}

List<LiveVirusConflict> liveConflictList(String cvx) {
  var conflictList = <LiveVirusConflict>[];
  SupportingData.scheduleSupportingData.liveVirusConflicts.forEach((dose) {
    if (dose.currentCvx == cvx) {
      conflictList.add(dose);
    }
  });
  return conflictList;
}

bool isThereConflict(LiveVirusConflict conflict, Dose dose, VaxDate dateGiven) {
  var conflictBeginIntDate =
      dose.dateGiven.maxIfNull(conflict.conflictBeginInterval);
  var conflictEndIntDate = dose.dateGiven.minIfNull(dose.valid()
      ? conflict.minConflictEndInterval
      : conflict.conflictEndInterval);
  return conflictBeginIntDate <= dateGiven && dateGiven < conflictEndIntDate;
}
