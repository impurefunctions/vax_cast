import 'package:dartz/dartz.dart';

import '../shared.dart';

part 'b_evaluate_dose_condition.dart';
part 'c_inadvertent.dart';
part 'd_age.dart';
part 'e_preferable_interval.dart';
part 'f_allowed_intervals.dart';
part 'g_live_conflicts.dart';
part 'h_preferable_vaccine.dart';
part 'i_allowable_vaccine.dart';
part 'j_seasonal.dart';

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
  Tuple2<bool, String> prefInt;
  Tuple2<bool, String> allowInt;
  Tuple2<bool, Dose> liveConflict;
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
    valid &= isValid;
    evaluation = Tuple2(
      evaluation.value1 == EvalStatus.valid
          ? evalStatus.value1
          : evaluation.value1,
      '${evaluation.value2}, ${evalStatus.value2}',
    );
  }

  void evaluateDoseCondition() {
    EvaluateDoseCondition attributes = EvaluateDoseCondition(
      dateGiven,
      lotExp,
      doseCondition,
    );
    if (attributes.cannotBeEvaluated()) {
      setStatus(
        attributes.getTarget(),
        attributes.getEvaluation(),
        false,
      );
    }
  }

  void evaluatePastDose(
      SeriesDose seriesDose, List<Dose> pastDoses, int targetDose) {
    evaluateInadvertent(seriesDose);
    if (valid) {
      evaluateSeasonRecommendation(seriesDose.seasonalRecommendation);
      if (valid) {
        var ageList = seriesDose.age;
        var currentIndex = pastDoses.indexOf(this);
        var pastDose = currentIndex == 0 ? null : pastDoses[currentIndex - 1];
        evaluateAge(ageList, pastDose, targetDose);
        if (valid) {
          evaluatePrefIntervals(seriesDose, pastDoses);
          evaluateAllowedIntervals(seriesDose, pastDoses);
          if (valid) {
            evaluateLiveVirusConflict();
            if (valid) {
              evaluatePreferableVaccine(seriesDose);
              evaluateAllowableVaccine(seriesDose);
              if (valid) validDose(targetDose);
            }
          }
        }
      }
    }
  }

  void evaluateSeasonRecommendation(SeasonalRecommendation recommendation) {
    if (Season.givenOutsideSeason(recommendation, dateGiven)) {
      setStatus(
        Season.getTarget(),
        Season.getEvaluation(),
        false,
      );
    }
  }

  void evaluateInadvertent(SeriesDose seriesDose) {
    if (Inadvertent.isInadvertentDose(seriesDose, cvx)) {
      setStatus(
        Inadvertent.getTarget(),
        Inadvertent.getEvaluation(),
        false,
      );
    }
  }

  void evaluateAge(List<VaxAge> ageList, Dose previousDose, int targetDose) {
    Age evalAge = Age(
      ageList,
      previousDose,
      targetDose,
      dateGiven,
      patient.dob,
    );
    age = evalAge.givenAtValidAge();
    if (!evalAge.validAge) {
      setStatus(
        evalAge.getTarget(),
        evalAge.getEvaluation(),
        false,
      );
    }
  }

  void evaluatePrefIntervals(SeriesDose seriesDose, List<Dose> pastDoses) {
    PreferableIntervals preferableIntervals = PreferableIntervals(
      seriesDose,
      pastDoses,
      this,
    );
    prefInt = preferableIntervals.checkPreferred();
  }

  void evaluateAllowedIntervals(SeriesDose seriesDose, List<Dose> pastDoses) {
    allowInt = AllowedIntervals.checkAllowed(seriesDose, pastDoses, this);
    if (!prefInt.value1 && !allowInt.value1) {
      setStatus(
        AllowedIntervals.getTarget(),
        AllowedIntervals.getEvaluation(prefInt.value2, allowInt.value2),
        false,
      );
    }
  }

  void evaluateLiveVirusConflict() {
    liveConflict = LiveConflicts.hasNoLiveVirusConflict(patient, this);
    if (liveConflict.value1) {
      setStatus(
        LiveConflicts.getTarget(),
        LiveConflicts.getEvaluation(),
        false,
      );
    }
  }

  void evaluatePreferableVaccine(SeriesDose seriesDose) {
    prefVax = PreferableVaccine.wasPreferable(seriesDose, patient.dob, this);
  }

  void evaluateAllowableVaccine(SeriesDose seriesDose) {
    allowVax = AllowableVaccine.wasAllowable(seriesDose, patient.dob, this);
    if (!allowVax.value1) {
      setStatus(
        AllowableVaccine.getTarget(),
        AllowableVaccine.getEvaluation(),
        false,
      );
    }
  }

  void validDose(int targetDose) {
    target = Tuple2(targetDose, target.value2 ?? TargetStatus.satisfied);
    valid = true;
    evaluation = Tuple2(EvalStatus.valid, 'valid dose');
  }
}
