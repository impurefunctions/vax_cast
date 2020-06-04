part of 'a_vax_series.dart';

class Skip {
  SeriesDose seriesDose;
  VaxPatient patient;
  Context context;
  bool anySeries;
  List<Dose> pastDoses;
  Skip(
    this.seriesDose,
    this.patient,
    this.context,
    this.anySeries,
    this.pastDoses,
  );

  bool skipNextDose() {
    List<ConditionalSkip> skipTarget = seriesDose.conditionalSkip;
    return skipTarget == null
        ? false
        : skipTarget[0].context == 'Both' || context == Context.evaluation
            ? isSkippable(skipTarget[0])
            : skipTarget.length == 1 ? false : isSkippable(skipTarget[1]);
  }

  bool isSkippable(ConditionalSkip condSkip) {
    for (final vaxSet in condSkip.vaxSet) {
      if (shouldSkip(vaxSet)) return true;
    }
    return false;
  }

  bool shouldSkip(VaxSet vaxSet) =>
      vaxSet.conditionLogic == null || vaxSet.conditionLogic == 'OR'
          ? orCondition(vaxSet)
          : andCondition(vaxSet);

  bool orCondition(VaxSet vaxSet) {
    for (final condition in vaxSet.condition) {
      if (isSkipConditionMet(condition)) return true;
    }
    return false;
  }

  bool andCondition(VaxSet vaxSet) {
    for (final condition in vaxSet.condition) {
      if (!isSkipConditionMet(condition)) return false;
    }
    return true;
  }

  bool isSkipConditionMet(Condition condition) {
    switch (condition.conditionType) {
      case 'Age':
        return ageCondition(condition);

      case 'Completed Series':
        return anySeries;

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
      patient.dob.minIfNull(condition.beginAge) <=
          (patient.assessmentDate ?? VaxDate.now()) &&
      (patient.assessmentDate ?? VaxDate.now()) <
          patient.dob.maxIfNull(condition.endAge);

  bool intervalCondition(Condition condition) {
    VaxDate refDate = patient.assessmentDate ?? VaxDate.now();
    if (pastDoses.isEmpty) return false;
    var date = VaxDate.min();
    pastDoses.forEach((dose) {
      if (dose.dateGiven < refDate && dose.dateGiven > date) {
        date = dose.dateGiven;
      }
    });
    return date == VaxDate.min()
        ? false
        : refDate >= date.change(condition.interval);
  }

  bool countCondition(Condition condition) {
    VaxDate refDate = patient.assessmentDate ?? VaxDate.now();
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
        addToCount &= pastDoses[i].target.value1 != -1;
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
