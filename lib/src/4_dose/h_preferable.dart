part of 'a_dose.dart';

Tuple2<bool, String> preferable(SeriesDose seriesDose, Dose dose) {
  var dob = dose.patient.dob;
  var prefIndex = seriesDose.preferableVaccine
      .indexWhere((preferable) => preferable.cvx == dose.cvx);
  if (prefIndex == -1) {
    return Tuple2(false, 'preferable vaccine not administered');
  } else {
    var prefVax = seriesDose.preferableVaccine[prefIndex];
    var prefBeginAgeDate = dob.minIfNull(prefVax.beginAge);
    var prefEndAgeDate = dob.maxIfNull(prefVax.endAge);
    if (prefBeginAgeDate > dose.dateGiven || dose.dateGiven >= prefEndAgeDate) {
      return Tuple2(false, 'administered out of preferred age range');
    } else if (prefVax.mvx == null ||
        prefVax.mvx == dose.mvx ||
        dose.mvx == null) {
      if (dose.vol == null || prefVax.volume == null) {
        return Tuple2(true, 'preferable vaccine administered');
      } else if (dose.vol >= int.parse(prefVax.volume)) {
        return Tuple2(true, 'preferable vaccine administered');
      } else {
        return Tuple2(false, 'less than recommended volume');
      }
    } else {
      return Tuple2(false, 'wrong trade name');
    }
  }
}
