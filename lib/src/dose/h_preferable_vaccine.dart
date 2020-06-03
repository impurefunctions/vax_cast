part of 'a_dose.dart';

abstract class PreferableVaccine {
  static Tuple2<bool, VaxReason> wasPreferable(
      SeriesDose seriesDose, VaxDate dob, Dose dose) {
    Tuple2<bool, VaxReason> preferVax;
    var prefIndex = seriesDose.preferableVaccine
        .indexWhere((preferable) => preferable.cvx == dose.cvx);
    if (prefIndex == -1) {
      preferVax = Tuple2(false, VaxReason.not_preferable);
    } else {
      var prefVax = seriesDose.preferableVaccine[prefIndex];
      var prefBeginAgeDate = dob.minIfNull(prefVax.beginAge);
      var prefEndAgeDate = dob.maxIfNull(prefVax.endAge);
      if (prefBeginAgeDate > dose.dateGiven ||
          dose.dateGiven >= prefEndAgeDate) {
        preferVax = Tuple2(false, VaxReason.out_of_age_range);
      } else if (prefVax.mvx == null ||
          prefVax.mvx == dose.mvx ||
          dose.mvx == null) {
        if (dose.vol == null || prefVax.volume == null) {
          preferVax = Tuple2(true, VaxReason.preferable);
        } else if (dose.vol >= int.parse(prefVax.volume)) {
          preferVax = Tuple2(true, VaxReason.preferable);
        } else {
          preferVax = Tuple2(false, VaxReason.less_than_recommended_volume);
        }
      } else {
        preferVax = Tuple2(false, VaxReason.wrong_trade_name);
      }
    }
    return preferVax;
  }
}
