part of 'a_recommended_dose.dart';

class IntervalRec {
  VaxDate minIntDate;
  VaxDate earliestRecIntDate;
  VaxDate latestRecIntDate;

  IntervalRec();

  void checkIntervals(List<Interval> intervals, List<Dose> pastDoses,
      List<Dose> pastImmunizations) {
    if (intervals != null) {
      for (final interval in intervals) {
        if (interval.fromPrevious == 'Y') {
          checkFromPrevious(pastDoses, interval);
        } else if (interval.fromTargetDose != null) {
          checkFromTargetDose(pastDoses, interval);
        } else if (interval.fromMostRecent != null) {
          checkFromMostRecent(interval, pastImmunizations);
        }
      }
    }
  }

  void checkFromMostRecent(Interval interval, List<Dose> pastImmunizations) {
    var pastCvx = interval.fromMostRecent.split(';');
    var indexDose = pastImmunizations
        .lastWhere((dose) => pastCvx.contains(dose.cvx), orElse: () => null);
    if (indexDose != null) {
      minIntDate = LatestOf(
          [minIntDate, indexDose.dateGiven.changeIfNotNull(interval.minInt)]);
      earliestRecIntDate = LatestOf([
        earliestRecIntDate,
        indexDose.dateGiven.changeIfNotNull(interval.earliestRecInt)
      ]);
      latestRecIntDate = LatestOf([
        latestRecIntDate,
        indexDose.dateGiven.changeIfNotNull(interval.latestRecInt)
      ]);
    }
  }

  void checkFromTargetDose(List<Dose> pastDoses, Interval interval) {
    Dose prevDose = pastDoses.firstWhere(
        (dose) => dose.target.value1 == int.parse(interval.fromTargetDose) - 1,
        orElse: () => null);
    if (prevDose != null) {
      minIntDate = LatestOf(
          [minIntDate, prevDose.dateGiven.changeIfNotNull(interval.minInt)]);
      earliestRecIntDate = LatestOf([
        earliestRecIntDate,
        prevDose.dateGiven.changeIfNotNull(interval.earliestRecInt)
      ]);
      latestRecIntDate = LatestOf([
        latestRecIntDate,
        (prevDose.dateGiven.changeIfNotNull(interval.latestRecInt))
      ]);
    }
  }

  void checkFromPrevious(List<Dose> pastDoses, Interval interval) {
    Dose lastDose = getLastDose(pastDoses);
    if (lastDose != null) {
      var dateGiven = lastDose.dateGiven;
      minIntDate =
          LatestOf([minIntDate, dateGiven.changeIfNotNull(interval.minInt)]);
      earliestRecIntDate = LatestOf([
        earliestRecIntDate,
        (dateGiven.changeIfNotNull(interval.earliestRecInt))
      ]);
      latestRecIntDate = LatestOf([
        latestRecIntDate,
        (dateGiven.changeIfNotNull(interval.latestRecInt))
      ]);
    }
  }

  Dose getLastDose(List<Dose> pastDoses) => pastDoses == null
      ? null
      : pastDoses.isEmpty
          ? null
          : pastDoses.lastWhere(
              (dose) => dose.evaluation.value2 != 'inadvertent administration',
              orElse: () => null);
}
