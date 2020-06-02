import 'package:dartz/dartz.dart';

import '../shared.dart';

part 'b_evaluate_dose_condition.dart';
part 'c_inadvertent.dart';
part 'd_age.dart';

class Dose {
  VaxDate dateGiven;
  VaxDate lotExp;
  String doseCondition;
  String cvx;
  String mvx;
  int vol;
  VaxPatient patient;
  Tuple2<int, TargetStatus> target;
  Tuple2<EvalStatus, String> evaluation;
  bool inadvertent;
  Tuple2<bool, AgeReason> age;
  Tuple2<bool, IntReason> prefInt;
  Tuple2<bool, IntReason> allowInt;
  Tuple2<bool, Dose> conflict;
  Tuple2<bool, VaxReason> prefVax;
  Tuple2<bool, VaxReason> allowVax;
  bool valid;

  Dose({
    this.dateGiven,
    this.cvx,
    this.mvx,
  }) {
    this.valid = true;
  }

  void setStatus(
    Tuple2<int, TargetStatus> targetStatus,
    Tuple2<EvalStatus, String> evalStatus,
    bool isValid,
  ) {
    target = targetStatus;
    evaluation = evalStatus;
    valid &= isValid;
  }

  void evaluateDoseCondition() {
    EvaluateDoseCondition attributes =
        EvaluateDoseCondition(dateGiven, lotExp, doseCondition);
    if (attributes.cannotBeEvaluated()) {
      setStatus(attributes.getTarget(), attributes.getEvaluation(), false);
    }
  }

  void evaluateInadvertent(SeriesDose seriesDose) {
    if (Inadvertent().isInadvertentDose(seriesDose, cvx)) {
      setStatus(
          Inadvertent().getTarget(), Inadvertent().getEvaluation(), false);
    }
  }

  void evaluateAge(List<VaxAge> ageList, Dose previousDose, int targetDose) {
    Age evalAge =
        Age(ageList, previousDose, targetDose, dateGiven, patient.dob);
    age = evalAge.givenAtValidAge();
    if (!evalAge.validAge) {
      setStatus(evalAge.getTarget(), evalAge.getEvaluation(), false);
    }
  }

  bool givenOutsideSeason(SeasonalRecommendation recommendation) =>
      recommendation == null
          ? false
          : VaxDate.max().fromNullableString(recommendation.endDate) <=
                  dateGiven ||
              dateGiven <
                  VaxDate.min().fromNullableString(recommendation.startDate);

  void setSeasonStatus() {
    targetDose = null;
    targetDoseStatus = 'not satisfied';
    evalReason = 'given outside seasonal recommendation';
  }

  bool hasValidIntervals(SeriesDose seriesDose, List<Dose> pastDoses) {
    if (seriesDose.interval == null && seriesDose.allowableInterval == null) {
      _sameIntReason('no interval requirement');
    } else if (pastDoses.indexWhere((pastDose) => pastDose == this) == 0) {
      _sameIntReason('first dose patient received');
    } else if (pastDoses.length == 1) {
      _sameIntReason('only 1 past dose');
    } else {
      checkIntervals(seriesDose, pastDoses);
    }
    return allowInt || prefInt;
  }

  void _sameIntReason(String reason) {
    prefInt = allowInt = true;
    prefReason = allowReason = 'no interval requirement';
  }

  void checkIntervals(SeriesDose seriesDose, List<Dose> pastDoses) {
    if (seriesDose.allowableInterval != null) {
      isAllowableInterval(seriesDose, pastDoses);
    } else {
      allowInt = false;
      allowReason = 'no allowable interval specified';
    }
    isPreferableInterval(seriesDose, pastDoses);
  }

  void isAllowableInterval(SeriesDose seriesDose, List<Dose> pastDoses) {
    var allowable = seriesDose.allowableInterval;
    var index;
    var compareDose;
    if (allowable.fromPrevious == 'Y') {
      index = pastDoses.indexWhere((pastDose) => pastDose == this) - 1;
      compareDose = 'previous dose';
    } else if (allowable.fromTargetDose != null) {
      index = pastDoses.indexWhere(
          (dose) => dose.targetDose == int.parse(allowable.fromTargetDose) - 1);
      compareDose = 'dose ${allowable.fromTargetDose}';
    }
    allowInt =
        dateGiven >= pastDoses[index].dateGiven.minIfNull(allowable.absMinInt);
    allowReason = '$compareDose too soon';
  }

  void isPreferableInterval(SeriesDose seriesDose, List<Dose> pastDoses) {
    var compareDose;
    for (final interval in seriesDose.interval) {
      var applyInterval = interval.effectiveDate != null
          ? dateGiven >= VaxDate.mmddyyyy(interval.effectiveDate)
          : true;
      applyInterval = interval.cessationDate != null
          ? applyInterval &&
              dateGiven < VaxDate.mmddyyyy(interval.cessationDate)
          : applyInterval;
      if (applyInterval) {
        var index;
        if (interval.fromPrevious == 'Y') {
          index = pastDoses.indexWhere((pastDose) => pastDose == this) - 1;
          compareDose = 'previous';
        } else if (interval.fromTargetDose != null) {
          index = pastDoses.indexWhere((dose) =>
              dose.targetDose == int.parse(interval.fromTargetDose) - 1);
          compareDose = '${interval.fromTargetDose}';
        } else if (interval.fromMostRecent != null) {
          index = pastDoses.lastIndexWhere(
              (pastDose) => interval.fromMostRecent.contains(cvx));
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

        if (dateGiven < absMinIntDate) {
          setPrefInt(false, compareDose, 'too soon');
        } else {
          if (absMinIntDate <= dateGiven && dateGiven < minIntDate) {
            if (seriesDose.doseNumber == 1) {
              setPrefInt(true, compareDose, 'grace period');
            } else {
              var previousDose = pastDoses[index];
              if ((previousDose?.validAge ?? true) &&
                  ((previousDose?.allowInt ?? true) ||
                      (previousDose?.prefInt ?? true))) {
                setPrefInt(true, compareDose, 'grace period');
              } else {
                setPrefInt(false, compareDose, 'too soon');
              }
            }
          } else if (minIntDate <= dateGiven) {
            setPrefInt(true, compareDose, 'grace period');
          } else {
            setPrefInt(false, compareDose, 'unable to evaluate');
          }
        }
      }
    }
  }

  void setPrefInt(bool pref, String compare, String reason) {
    prefInt = prefInt == null ? pref : prefInt && pref;
    prefReason = prefReason == null
        ? '$reason from dose $compare'
        : prefReason += ', $reason from dose $compare';
  }

  void notValidIntervals() {
    targetDose = null;
    targetDoseStatus = 'not satisfied';
    valid = false;
    status = 'not valid';
    evalReason = '$prefReason, $allowReason';
  }

  bool hasNoLiveVirusConflict() {
    var liveConflict = false;
    if (patient.liveVirusList.isNotEmpty) {
      var liveVaccines = <Dose>[];
      patient.liveVirusList.forEach((dose) {
        if (dose.dateGiven < dateGiven) {
          liveVaccines.add(dose);
        }
      });
      if (liveVaccines.isNotEmpty) {
        var liveConflicts = <LiveVirusConflict>[];
        SupportingData.scheduleSupportingData.liveVirusConflicts
            .forEach((dose) {
          if (dose.currentCvx == cvx) {
            liveConflicts.add(dose);
          }
        });
        if (liveConflicts.isNotEmpty) {
          for (final conflict in liveConflicts) {
            var index = liveVaccines
                .indexWhere((dose) => dose.cvx == conflict.previousCvx);
            if (index != -1) {
              liveConflict = liveConflict ||
                  conflict.isThereConflict(liveVaccines[index], dateGiven);
            }
          }
        }
      }
    }
    return !liveConflict;
  }

  void hasLiveVirusConflict() {
    targetDose = null;
    targetDoseStatus = 'not satisfied';
    valid = false;
    status = 'not valid';
    evalReason = 'live virus conflict';
  }

  void wasPreferable(SeriesDose seriesDose) {
    var dob = patient.dob;
    var prefIndex = seriesDose.preferableVaccine
        .indexWhere((preferable) => preferable.cvx == cvx);
    if (prefIndex == -1) {
      preferVax = false;
      preferVaxReason = 'preferable vaccine not administered';
    } else {
      var prefVax = seriesDose.preferableVaccine[prefIndex];
      var prefBeginAgeDate = dob.minIfNull(prefVax.beginAge);
      var prefEndAgeDate = dob.maxIfNull(prefVax.endAge);
      if (prefBeginAgeDate > dateGiven || dateGiven >= prefEndAgeDate) {
        preferVax = false;
        preferVaxReason = 'administered out of preferred age range';
      } else if (prefVax.mvx == null || prefVax.mvx == mvx || mvx == null) {
        if (vol == null || prefVax.volume == null) {
          preferVax = true;
          preferVaxReason = 'preferable vaccine administered';
        } else if (vol >= int.parse(prefVax.volume)) {
          preferVax = true;
          preferVaxReason = 'preferable vaccine administered';
        } else {
          preferVax = false;
          preferVaxReason = 'less than recommended volume';
        }
      } else {
        preferVax = false;
        preferVaxReason = 'wrong trade name';
      }
    }
  }

  bool wasAllowable(SeriesDose seriesDose) {
    var dob = patient.dob;
    if (seriesDose.allowableVaccine == null) {
      allowVax = true;
      allowVaxReason = 'allowable vaccine is null';
    } else {
      var allowIndex = seriesDose.allowableVaccine
          .indexWhere((allowable) => allowable.cvx == cvx);
      if (allowIndex == -1) {
        allowVax = false;
        allowVaxReason = 'allowable vaccine not administered';
      } else {
        var allowableVax = seriesDose.allowableVaccine[allowIndex];
        var allowBeginAgeDate = dob.minIfNull(allowableVax.beginAge);
        var allowEndAgeDate = dob.maxIfNull(allowableVax.endAge);
        if (allowBeginAgeDate <= dateGiven && dateGiven < allowEndAgeDate) {
          allowVax = true;
          allowVaxReason = 'allowed vaccine was administered';
        } else {
          allowVax = false;
          allowVaxReason = 'administered out of allowable age range';
        }
      }
    }
    return allowVax;
  }

  void notAllowable() {
    targetDose = null;
    targetDoseStatus = 'not satisfied';
    valid = false;
    status = 'not valid';
    evalReason = 'not allowable';
  }

  void validDose(int targetDose) {
    this.targetDose = targetDose;
    targetDoseStatus ??= 'satisfied';
    valid = true;
    status = 'valid';
    evalReason = 'valid dose';
  }

  void isSubStandard() {
    targetDose = null;
    targetDoseStatus = 'not satisfied';
    valid = false;
    status = 'sub-standard';
    evalReason = 'sub-standard';
  }

  void skipDose() {
    targetDose = null;
    targetDoseStatus = 'skipped';
    status = 'skipped';
    evalReason = 'skipped';
  }
}
