part of 'a_vax_series.dart';

class Skippable {
  ConditionalSkip skip;
  VaxDate refDate;
  bool anySeriesComplete;
  VaxPatient patient;
  List<Dose> pastDoses;

  Skippable(this.refDate, this.anySeriesComplete, this.patient, this.pastDoses);

  bool checkSkipDate(SeriesDose seriesDose, String context) {
    var curTargetSkip = seriesDose.conditionalSkip;
    return curTargetSkip == null
        ? false
        : correctContext(context, curTargetSkip[0])
            ? isSkippable(curTargetSkip[0])
            : curTargetSkip.length == 1
                ? false
                : correctContext(context, curTargetSkip[1])
                    ? isSkippable(curTargetSkip[1])
                    : false;
  }

  bool correctContext(String compareContext, ConditionalSkip oldSkip) =>
      (oldSkip.context == 'Both' || oldSkip.context == compareContext);

  bool isSkippable(ConditionalSkip newSkip) {
    skip = newSkip;
    for (final vaxSet in skip.vaxSet) {
      if (shouldBeSkipped(vaxSet)) return true;
    }
    return false;
  }

  bool shouldBeSkipped(VaxSet vaxSet) => canUseOrLogic(vaxSet.conditionLogic)
      ? orCondition(vaxSet)
      : andCondition(vaxSet);

  bool canUseOrLogic(String logic) => (logic == null || logic == 'OR');

  bool orCondition(VaxSet vaxSet) {
    for (final condition in vaxSet.condition) {
      if (isSkipConditionMet(condition)) {
        return true;
      }
    }
    return false;
  }

  bool andCondition(VaxSet vaxSet) {
    for (final condition in vaxSet.condition) {
      if (!isSkipConditionMet(condition)) {
        return false;
      }
    }
    return true;
  }

  bool isSkipConditionMet(Condition condition) {
    switch (condition.conditionType) {
      case 'Age':
        return ageCondition(condition);

      case 'Completed Series':
        return anySeriesComplete;

      case 'Interval':
        return intervalCondition(condition);

      case 'Vaccine Count by Age':
        return countCondition(condition);

      case 'Vaccine Count by Date':
        return countCondition(condition);
    }
    return false;
  }

  bool ageCondition(Condition condition) =>
      patient.dob.minIfNull(condition.beginAge) <= refDate &&
      refDate < patient.dob.maxIfNull(condition.endAge);

  bool intervalCondition(Condition condition) {
    if (pastDoses.isEmpty) return false;
    var date = VaxDate.min();
    pastDoses.forEach((dose) {
      //=?
      if (dose.dateGiven < refDate) {
        date = dose.dateGiven > date ? dose.dateGiven : date;
      }
    });
    return date == VaxDate.min()
        ? false
        : refDate >= date.change(condition.interval);
  }

  bool countCondition(Condition condition) {
    if (pastDoses.isEmpty) return false;
    var count = 0;
    var doses = <Dose>[];
    pastDoses.forEach((dose) {
      if (dose.dateGiven <= refDate) doses.add(dose);
    });
    for (var i = 0; i < doses.length; i++) {
      var addToCount = true;
      if (condition.conditionType == 'Vaccine Count by Age') {
        addToCount = addToCountByAge(condition, doses.elementAt(i));
      } else if (condition.conditionType == 'Vaccine Count by Date') {
        addToCount = addToCountByDate(condition, doses.elementAt(i));
      }
      if (condition.vaccineTypes != null) {
        addToCount &= addToCountByType(condition, doses.elementAt(i));
      }
      if (condition.doseType == 'Valid') {
        addToCount &= pastDoses[i].valid();
      }

      count += addToCount ? 1 : 0;
    }
    return condition.doseCountLogic == 'greater than'
        ? count > int.parse(condition.doseCount)
        : condition.doseCountLogic == 'equal to'
            ? count == int.parse(condition.doseCount)
            : count < int.parse(condition.doseCount);
  }

  bool addToCountByAge(Condition condition, Dose dose) =>
      patient.dob.maxIfNull(condition.endAge) > dose.dateGiven &&
      dose.dateGiven >= patient.dob.minIfNull(condition.beginAge);

  bool addToCountByDate(Condition condition, Dose dose) =>
      VaxDate.min().fromNullableString(condition.startDate) <= dose.dateGiven &&
      dose.dateGiven < VaxDate.max().fromNullableString(condition.endDate);

  bool addToCountByType(Condition condition, Dose dose) =>
      condition.vaccineTypes.contains(dose.cvx);
}
