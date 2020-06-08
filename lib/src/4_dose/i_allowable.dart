part of 'a_dose.dart';

Tuple2<bool, String> allowable(SeriesDose seriesDose, Dose dose) {
  var dob = dose.patient.dob;
  if (seriesDose.allowableVaccine == null) {
    return Tuple2(true, 'allowable vaccine is null');
  } else {
    var allowIndex = seriesDose.allowableVaccine
        .indexWhere((allowable) => allowable.cvx == dose.cvx);
    if (allowIndex == -1) {
      return Tuple2(false, 'allowable vaccine not administered');
    } else {
      var allowableVax = seriesDose.allowableVaccine[allowIndex];
      var allowBeginAgeDate = dob.minIfNull(allowableVax.beginAge);
      var allowEndAgeDate = dob.maxIfNull(allowableVax.endAge);
      if (allowBeginAgeDate <= dose.dateGiven &&
          dose.dateGiven < allowEndAgeDate) {
        return Tuple2(true, 'allowed vaccine was administered');
      } else {
        return Tuple2(false, 'administered out of allowable age range');
      }
    }
  }
}
