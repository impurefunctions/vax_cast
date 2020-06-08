part of 'a_dose.dart';

Tuple2<bool, String> preferableIntervals(
        SeriesDose seriesDose, List<Dose> pastDoses, Dose dose) =>
    seriesDose.interval == null
        ? Tuple2(true, 'no interval requirement')
        : pastDoses.length == 1
            ? Tuple2(true, 'only 1 past dose')
            : pastDoses.indexOf(dose) == 0
                ? Tuple2(true, 'first dose patient received')
                : isPreferableInterval(seriesDose, pastDoses, dose);

Tuple2<bool, String> isPreferableInterval(
    SeriesDose seriesDose, List<Dose> pastDoses, Dose dose) {
  Tuple2<bool, String> prefInt;
  var compareDose;
  for (final interval in seriesDose.interval) {
    var applyInterval = interval.effectiveDate != null
        ? dose.dateGiven >= VaxDate.mmddyyyy(interval.effectiveDate)
        : true;
    applyInterval = interval.cessationDate != null
        ? applyInterval &&
            dose.dateGiven < VaxDate.mmddyyyy(interval.cessationDate)
        : applyInterval;
    if (applyInterval) {
      var index;
      if (interval.fromPrevious == 'Y') {
        index = pastDoses.indexOf(dose) - 1;
        compareDose = 'previous';
      } else if (interval.fromTargetDose != null) {
        index = pastDoses.indexWhere((dose) =>
            dose.target.value1 == int.parse(interval.fromTargetDose) - 1);
        compareDose = '${interval.fromTargetDose}';
      } else if (interval.fromMostRecent != null) {
        index = pastDoses.lastIndexWhere(
            (pastDose) => interval.fromMostRecent.contains(dose.cvx));
      }

      var absMinIntDate;
      var minIntDate;
      if (index == -1) {
        absMinIntDate = minIntDate = VaxDate.min();
      } else {
        absMinIntDate =
            pastDoses[index].dateGiven.minIfNull(interval.absMinInt);
        minIntDate = pastDoses[index].dateGiven.minIfNull(interval.minInt);
      }

      if (dose.dateGiven < absMinIntDate) {
        prefInt = setPrefInt(false, compareDose, 'too soon', prefInt);
      } else {
        if (absMinIntDate <= dose.dateGiven && dose.dateGiven < minIntDate) {
          if (seriesDose.doseNumber == 1) {
            prefInt = setPrefInt(true, compareDose, 'grace period', prefInt);
          } else {
            var previousDose = pastDoses[index];
            if ((previousDose?.validAge?.value1 ?? true) &&
                ((previousDose?.allowInt?.value1 ?? true) ||
                    (previousDose?.prefInt?.value1 ?? true))) {
              prefInt = setPrefInt(true, compareDose, 'grace period', prefInt);
            } else {
              prefInt = setPrefInt(false, compareDose, 'too soon', prefInt);
            }
          }
        } else if (minIntDate <= dose.dateGiven) {
          prefInt = setPrefInt(true, compareDose, 'grace period', prefInt);
        } else {
          prefInt =
              setPrefInt(false, compareDose, 'unable to evaluate', prefInt);
        }
      }
    }
  }
  return prefInt;
}

Tuple2<bool, String> setPrefInt(bool pref, String compare, String reason,
        Tuple2<bool, String> prefInt) =>
    Tuple2(
        prefInt == null ? pref : prefInt.value1 && pref,
        prefInt == null
            ? '$reason from dose $compare'
            : '${prefInt.value2}, $reason from dose $compare');
