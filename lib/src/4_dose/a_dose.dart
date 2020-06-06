import 'package:dartz/dartz.dart';
import 'package:vax_cast/src/9_shared/shared.dart';

class Dose {
  VaxDate dateGiven;
  VaxDate lotExp;
  String doseCondition;
  String cvx;
  Tuple2<int, TargetStatus> target;
  bool valid;
  Tuple2<EvalStatus, String> evaluation;
  VaxPatient patient;
  String mvx;
  int vol;
  bool preferVax;
  String preferVaxReason;
  bool allowVax;
  String allowVaxReason;
  bool validAge;
  String ageReason;
  bool prefInt;
  String prefReason;
  bool allowInt;
  String allowReason;
  Dose({
    this.dateGiven,
    lotExp,
    this.doseCondition,
    this.cvx,
    this.valid = false,
    this.patient,
    this.mvx,
    this.vol,
    this.preferVax,
    this.preferVaxReason = '',
    this.allowVax,
    this.allowVaxReason = '',
    this.validAge = false,
    this.ageReason = '',
    this.prefInt,
    this.prefReason,
    this.allowInt,
    this.allowReason,
  }) : lotExp = VaxDate(2999, 12, 31);

  Dose.copy(Dose oldDose) {
    target = oldDose.target;
    dateGiven = oldDose.dateGiven;
    lotExp = oldDose.lotExp;
    doseCondition = oldDose.doseCondition;
    cvx = oldDose.cvx;
    mvx = oldDose.mvx;
    vol = oldDose.vol;
    evaluation = oldDose.evaluation;
    preferVax = oldDose.preferVax;
    preferVaxReason = oldDose.preferVaxReason;
    allowVax = oldDose.allowVax;
    allowVaxReason = oldDose.allowVaxReason;
    valid = oldDose.valid;
    validAge = oldDose.validAge;
    ageReason = oldDose.ageReason;
    prefInt = oldDose.prefInt;
    prefReason = oldDose.prefReason;
    allowInt = oldDose.allowInt;
    allowReason = oldDose.allowReason;
  }

  bool canBeEvaluated() => dateGiven <= lotExp && doseCondition == null;

  void unsatisfiedTarget() =>  target = Tuple2(-1, TargetStatus.not_satisfied);

  void setNotValid(String reason){ 
    unsatisfiedTarget();
    evaluation = Tuple2(EvalStatus.not_valid, '$reason');

  }

  bool isInadvertentDose(SeriesDose seriesDose) =>
      seriesDose.inadvertentVaccine == null
          ? false
          : seriesDose.inadvertentVaccine
                      .indexWhere((vaccine) => vaccine.cvx == cvx) ==
                  -1
              ? false
              : true;

  void setInadvertentStatus() {
    setNotValid('inadvertent administration');
    valid = false;
  }

  bool givenOutsideSeason(SeasonalRecommendation recommendation) =>
      recommendation == null
          ? false
          : VaxDate.max().fromNullableString(recommendation.endDate) <=
                  dateGiven ||
              dateGiven <
                  VaxDate.min().fromNullableString(recommendation.startDate);

  void setSeasonStatus() {
    unsatisfiedTarget();
    evaluation = Tuple2(null, '${evaluation?.value2}, given outside seasonal recommendation');
  }

  bool givenAtValidAge(List<VaxAge> ageList, Dose pastDose, int targetDose) {
    var vaxAge = setDoseAge(ageList);
    validateAge(vaxAge, pastDose, targetDose);
    return validAge;
  }

  VaxAge setDoseAge(List<VaxAge> ageList) {
    for (var age in ageList) {
      if (age.effectiveDate == null && age.cessationDate == null) {
        return age;
      }
      if (age.effectiveDate != null && age.cessationDate == null) {
        if (VaxDate.mmddyyyy(age.effectiveDate) <= dateGiven) {
          return age;
        }
      } else if (age.cessationDate != null && age.effectiveDate == null) {
        if (dateGiven < VaxDate.mmddyyyy(age.cessationDate)) {
          return age;
        }
      } else if (dateGiven < VaxDate.mmddyyyy(age.cessationDate) &&
          VaxDate.mmddyyyy(age.effectiveDate) <= dateGiven) {
        return age;
      }
    }
    return ageList[0];
  }

  void validateAge(VaxAge age, Dose pastDose, int targetDose) {
    var absMinAgeDate = patient.dob.minIfNull(age.absMinAge);
    var minAgeDate = patient.dob.minIfNull(age.minAge);
    var maxAgeDate = patient.dob.maxIfNull(age.maxAge);
    if (dateGiven < absMinAgeDate) {
      setAgeStatus(false, 'too young');
    } else if (absMinAgeDate <= dateGiven && dateGiven < minAgeDate) {
      if (pastDose == null) {
        setAgeStatus(true, 'grace period');
      } else if (targetDose == 0) {
        setAgeStatus(true, 'grace period');
      } else if (pastDose.validAge && (pastDose.allowInt || pastDose.prefInt)) {
        setAgeStatus(true, 'grace period');
      } else {
        setAgeStatus(false, 'too young');
      }
    } else if (minAgeDate <= dateGiven && dateGiven < maxAgeDate) {
      setAgeStatus(true, 'valid age');
    } else if (dateGiven >= maxAgeDate) {
      setAgeStatus(false, 'too old');
    } else {
      setAgeStatus(false, 'unable to evaluate date');
    }
  }

  void setAgeStatus(bool valid, String reason) {
    validAge = valid;
    ageReason = reason;
  }

  void notValidAge() {
    setNotValid(ageReason);
    valid = false;
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
      index = pastDoses.indexWhere((dose) =>
          dose.target.value1 == int.parse(allowable.fromTargetDose) - 1);
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
              dose.target.value1 == int.parse(interval.fromTargetDose) - 1);
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
    setNotValid('$prefReason, $allowReason');
    valid = false;
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
                  isThereConflict(conflict, liveVaccines[index], dateGiven);
            }
          }
        }
      }
    }
    return !liveConflict;
  }

  bool isThereConflict(
      LiveVirusConflict conflict, Dose dose, VaxDate dateGiven) {
    var conflictBeginIntDate =
        dose.dateGiven.maxIfNull(conflict.conflictBeginInterval);
    var conflictEndIntDate = dose.dateGiven.minIfNull(dose.valid
        ? conflict.minConflictEndInterval
        : conflict.conflictEndInterval);
    return conflictBeginIntDate <= dateGiven && dateGiven < conflictEndIntDate;
  }

  void hasLiveVirusConflict() {
    setNotValid('live virus conflict');
    valid = false;
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
    setNotValid('not allowable');
    valid = false;
  }

  void validDose(int targetDose) {
    target = Tuple2(targetDose, TargetStatus.satisfied);
    valid = true;
    evaluation = Tuple2(EvalStatus.valid,'valid dose');
  }

  void isSubStandard() {
    unsatisfiedTarget();
    valid = false;
    evaluation = Tuple2(EvalStatus.sub_standard, 'sub-standard');
  }

  void skipDose() {
    target = Tuple2(-1, TargetStatus.skipped);
    evaluation = Tuple2(EvalStatus.skipped, 'skipped');
  }
}
