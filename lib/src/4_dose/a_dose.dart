import 'package:dartz/dartz.dart';
import 'package:vax_cast/src/9_shared/shared.dart';

part 'b_inadvertent.dart';
part 'c_seasonal.dart';
part 'd_age_dose.dart';
part 'e_preferable_intervals.dart';
part 'f_allowable_intervals.dart';
part 'g_conflict.dart';
part 'h_preferable.dart';
part 'i_allowable.dart';

class Dose {
  VaxDate dateGiven;
  VaxDate lotExp;
  String doseCondition;
  String cvx;
  Tuple2<int, TargetStatus> target;
  Tuple2<EvalStatus, String> evaluation;
  VaxPatient patient;
  String mvx;
  int vol;
  Tuple2<bool, String> validAge;
  Tuple2<bool, String> prefInt;
  Tuple2<bool, String> allowInt;
  Tuple2<bool, int> conflict;
  Tuple2<bool, String> preferVax;
  Tuple2<bool, String> allowVax;
  Dose({
    this.dateGiven,
    lotExp,
    this.doseCondition,
    this.cvx,
    this.patient,
    this.mvx,
    this.vol,
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
  }

  bool canBeEvaluated() => dateGiven <= lotExp && doseCondition == null;

  void unsatisfiedTarget() => target = Tuple2(-1, TargetStatus.not_satisfied);

  bool invalid() => evaluation?.value1 != EvalStatus.valid;

  bool valid() => evaluation?.value1 == EvalStatus.valid;

  void setNotValid(String reason) {
    unsatisfiedTarget();
    evaluation = Tuple2(EvalStatus.not_valid, '$reason');
  }

  void evaluatePastDose(
          SeriesDose seriesDose, int targetDose, List<Dose> pastDoses) =>
      !inadvertentDose(seriesDose, cvx)
          ? evaluateNotInadvertentDose(seriesDose, targetDose, pastDoses)
          : setNotValid('inadvertent administration');

  void evaluateNotInadvertentDose(
      SeriesDose seriesDose, int targetDose, List<Dose> pastDoses) {
    evalSeasonal(seriesDose);
    var currentIndex = pastDoses.indexOf(this);
    var pastDose = currentIndex == 0 ? null : pastDoses[currentIndex - 1];
    validAge = setAgeStatus(
        seriesDose.age, pastDose, targetDose, dateGiven, patient.dob);
    validAge.value1
        ? evaluateValidAgeDose(seriesDose, targetDose, pastDoses)
        : setNotValid(validAge.value2.toString());
  }

  void evaluateValidAgeDose(
      SeriesDose seriesDose, int targetDose, List<Dose> pastDoses) {
    var prefInterval = preferableIntervals(seriesDose, pastDoses, this);
    allowInt = allowableIntervals(seriesDose, pastDoses, this);
    prefInt = prefInterval;
    allowInt.value1 || prefInt.value1
        ? evaluateValidIntervalDose(seriesDose, targetDose)
        : setNotValid('${prefInt.value2}, ${allowInt.value2}');
  }

  void evaluateValidIntervalDose(SeriesDose seriesDose, int targetDose) {
    conflict = evalLiveVirusConflict(patient, cvx, dateGiven);
    !conflict.value1
        ? evaluateNonConflictedDose(seriesDose, targetDose)
        : setNotValid('live virus conflict');
  }

  void evaluateNonConflictedDose(SeriesDose seriesDose, int targetDose) {
    preferVax = preferable(seriesDose, this);
    allowVax = allowable(seriesDose, this);
    allowVax.value1 ? validDose(targetDose) : setNotValid('not allowable');
  }

  void evalSeasonal(SeriesDose seriesDose) {
    if (givenOutsideSeason(seriesDose.seasonalRecommendation, dateGiven)) {
      unsatisfiedTarget();
      evaluation = Tuple2(
          null, '${evaluation?.value2}, given outside seasonal recommendation');
    }
  }

  void validDose(int targetDose) {
    target = Tuple2(targetDose, TargetStatus.satisfied);
    evaluation = Tuple2(EvalStatus.valid, 'valid dose');
  }

  void isSubStandard() {
    unsatisfiedTarget();
    evaluation = Tuple2(EvalStatus.sub_standard, 'sub-standard');
  }

  void skipDose() {
    target = Tuple2(-1, TargetStatus.skipped);
    evaluation = Tuple2(EvalStatus.skipped, 'skipped');
  }
}
