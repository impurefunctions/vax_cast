part of 'a_dose.dart';

Tuple2<bool, String> allowableIntervals(
        SeriesDose seriesDose, List<Dose> pastDoses, Dose dose) =>
    seriesDose.allowableInterval == null
        ? Tuple2(false, 'no allowable interval requirement')
        : pastDoses.length == 1
            ? Tuple2(true, 'only 1 dose in series')
            : pastDoses.indexOf(dose) == 0
                ? Tuple2(true, 'first dose patient received')
                : isAllowableInterval(
                    seriesDose.allowableInterval, pastDoses, dose);

Tuple2<bool, String> isAllowableInterval(
    Interval allowable, List<Dose> pastDoses, Dose dose) {
  var index;
  var compareDose;
  if (allowable.fromPrevious == 'Y') {
    index = pastDoses.indexOf(dose) - 1;
    compareDose = 'previous dose';
  } else if (allowable.fromTargetDose != null) {
    index = pastDoses.indexWhere((dose) =>
        dose.target.value1 == int.parse(allowable.fromTargetDose) - 1);
    compareDose = 'dose ${allowable.fromTargetDose}';
  }
  return Tuple2(
      dose.dateGiven >=
          pastDoses[index].dateGiven.minIfNull(allowable.absMinInt),
      '$compareDose too soon');
}
