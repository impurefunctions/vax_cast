import 'package:dartz/dartz.dart';
import 'package:vax_cast/src/9_shared/shared.dart';

part 'b_inadvertent.dart';
part 'c_seasonal.dart';
part 'd_age_dose.dart';
part 'e_preferable_intervals.dart';

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
  Tuple2<bool, String> validAge;
  Tuple2<bool, String> prefInt;
  Tuple2<bool, String> allowInt;
  bool preferVax;
  String preferVaxReason;
  bool allowVax;
  String allowVaxReason;
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
    allowInt = oldDose.allowInt;
    allowReason = oldDose.allowReason;
  }

  bool canBeEvaluated() => dateGiven <= lotExp && doseCondition == null;

  void unsatisfiedTarget() => target = Tuple2(-1, TargetStatus.not_satisfied);

  void setNotValid(String reason) {
    unsatisfiedTarget();
    evaluation = Tuple2(EvalStatus.not_valid, '$reason');
  }

  void evaluatePastDose(
      SeriesDose seriesDose, int targetDose, List<Dose> pastDoses) {
    if (isInadvertentDose(seriesDose, cvx)) {
      setInadvertentStatus();
    } else {
      if (givenOutsideSeason(seriesDose.seasonalRecommendation, dateGiven)) {
        setSeasonStatus();
      }
      var currentIndex = pastDoses.indexOf(this);
      var pastDose = currentIndex == 0 ? null : pastDoses[currentIndex - 1];
      validAge = setAgeStatus(
          seriesDose.age, pastDose, targetDose, dateGiven, patient.dob);
      if (validAge.value1) {
        prefInt = preferableIntervals(seriesDose, pastDoses, this);
        if (hasValidIntervals(seriesDose, pastDoses) || prefInt.value1) {
          if (hasNoLiveVirusConflict()) {
            wasPreferable(seriesDose);
            if (wasAllowable(seriesDose)) {
              validDose(targetDose);
            } else {
              notAllowable();
            }
          } else {
            hasLiveVirusConflict();
          }
        } else {
          notValidIntervals();
        }
      } else {
        setInvalidAge();
      }
    }
  }

  void setInadvertentStatus() {
    setNotValid('inadvertent administration');
    valid = false;
  }

  void setSeasonStatus() {
    unsatisfiedTarget();
    evaluation = Tuple2(
        null, '${evaluation?.value2}, given outside seasonal recommendation');
  }

  void setInvalidAge() {
    setNotValid(validAge.value2.toString());
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
    return allowInt;
  }

  void _sameIntReason(String reason) {
    allowInt = true;
    allowReason = 'no interval requirement';
  }

  void checkIntervals(SeriesDose seriesDose, List<Dose> pastDoses) {
    if (seriesDose.allowableInterval != null) {
      isAllowableInterval(seriesDose, pastDoses);
    } else {
      allowInt = false;
      allowReason = 'no allowable interval specified';
    }
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

  void notValidIntervals() {
    setNotValid('${prefInt.value2}, $allowReason');
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
    evaluation = Tuple2(EvalStatus.valid, 'valid dose');
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
