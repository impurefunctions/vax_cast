import 'package:dartz/dartz.dart';

import '../shared.dart';

part 'b_evaluate_dose_condition.dart';

class Dose {
  VaxDate dateGiven;
  VaxDate lotExp;
  String doseCondition;
  String cvx;
  String mvx;
  int vol;
  Tuple2<int, TargetStatus> target;
  Tuple2<EvalStatus, String> evaluation;

  Dose({
    this.dateGiven,
    this.cvx,
    this.mvx,
  });

  void targetUnsatisfied() => target = Tuple2(-1, TargetStatus.not_satisfied);

  void evalCondition() {
    evaluation = evaluateDoseCondition(lotExp, doseCondition, dateGiven);
    if (evaluation != null) targetUnsatisfied();
  }
}
