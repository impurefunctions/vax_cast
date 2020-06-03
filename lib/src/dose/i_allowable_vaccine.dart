part of 'a_dose.dart';

abstract class AllowableVaccine {
  static Tuple2<bool, VaxReason> wasAllowable(
      SeriesDose seriesDose, VaxDate dob, Dose dose) {
    Tuple2<bool, VaxReason> allowVax;
    if (seriesDose.allowableVaccine == null) {
      allowVax = Tuple2(true, VaxReason.none_specified);
    } else {
      var allowIndex = seriesDose.allowableVaccine
          .indexWhere((allowable) => allowable.cvx == dose.cvx);
      if (allowIndex == -1) {
        allowVax = Tuple2(false, VaxReason.not_allowable);
      } else {
        var allowableVax = seriesDose.allowableVaccine[allowIndex];
        var allowBeginAgeDate = dob.minIfNull(allowableVax.beginAge);
        var allowEndAgeDate = dob.maxIfNull(allowableVax.endAge);
        if (allowBeginAgeDate <= dose.dateGiven &&
            dose.dateGiven < allowEndAgeDate) {
          allowVax = Tuple2(true, VaxReason.allowable);
        } else {
          allowVax = Tuple2(false, VaxReason.out_of_age_range);
        }
      }
    }
    return allowVax;
  }

  static Tuple2<int, TargetStatus> getTarget() =>
      Tuple2(-1, TargetStatus.not_satisfied);

  static Tuple2<EvalStatus, String> getEvaluation() =>
      Tuple2(EvalStatus.not_valid, 'not allowable');
}
