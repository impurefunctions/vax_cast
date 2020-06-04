part of 'a_dose.dart';

class PreferableIntervals {
  SeriesDose seriesDose;
  List<Dose> pastDoses;
  Dose dose;
  bool valid;
  String prefIntReason;

  PreferableIntervals(this.seriesDose, this.pastDoses, this.dose) {
    valid = true;
    prefIntReason = '';
  }

  Tuple2<bool, String> checkPreferred() {
    if (seriesDose.interval == null) {
      valid = true;
      prefIntReason = 'no interval requirement';
    } else if (pastDoses.indexOf(dose) == 0) {
      valid = true;
      prefIntReason = 'first dose patient received';
    } else {
      isPreferableInterval();
    }
    return Tuple2(valid, prefIntReason);
  }

  void isPreferableInterval() {
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
        interval.fromPrevious == 'Y'
            ? {
                index = pastDoses.indexOf(dose) - 1,
                compareDose = 'previous',
              }
            : interval.fromTargetDose != null
                ? {
                    index = pastDoses.indexWhere((dose) =>
                        dose.target.value1 ==
                        int.parse(interval.fromTargetDose) - 1),
                    compareDose = '${interval.fromTargetDose}'
                  }
                : interval.fromMostRecent != null
                    ? index = pastDoses.lastIndexWhere((pastDose) =>
                        interval.fromMostRecent.contains(dose.cvx))
                    : null;

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
          addToReason('too soon from $compareDose', false);
        } else {
          if (absMinIntDate <= dose.dateGiven && dose.dateGiven < minIntDate) {
            if (seriesDose.doseNumber == 1) {
              addToReason('grace period from $compareDose', true);
            } else {
              var previousDose = pastDoses[index];
              if ((previousDose?.age?.value1 ?? true) &&
                  ((previousDose?.allowInt?.value1 ?? true) ||
                      (previousDose?.prefInt?.value1 ?? true))) {
                addToReason('grace period from $compareDose', true);
              } else {
                addToReason('too soon from $compareDose', false);
              }
            }
          } else if (minIntDate <= dose.dateGiven) {
            addToReason('grace period from $compareDose', true);
          } else {
            addToReason('unable to evaluate from $compareDose', false);
          }
        }
      }
    }
  }

  void addToReason(String reason, bool stillValid) {
    valid &= stillValid;
    prefIntReason += prefIntReason == '' ? reason : ', $reason';
  }
}
