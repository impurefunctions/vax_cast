part of 'a_dose.dart';

class EvaluateDoseCondition {
  VaxDate dateGiven;
  VaxDate lotExp;
  String doseCondition;

  EvaluateDoseCondition(this.dateGiven, this.lotExp, this.doseCondition) {
    lotExp ??= VaxDate.max();
  }

  bool cannotBeEvaluated() => dateGiven > lotExp || doseCondition != null;

  Tuple2<int, TargetStatus> getTarget() =>
      Tuple2(-1, TargetStatus.not_satisfied);

  Tuple2<EvalStatus, String> getEvaluation() => dateGiven > lotExp
      ? Tuple2(EvalStatus.sub_standard, 'expired')
      : Tuple2(EvalStatus.sub_standard, 'bad condition');
}
