part of 'a_dose.dart';

Tuple2<EvalStatus, String> evaluateDoseCondition(
    VaxDate lotExp, String doseCondition, VaxDate dateGiven) {
  lotExp ??= VaxDate.max();

  return dateGiven > lotExp
      ? Tuple2(EvalStatus.sub_standard, 'expired')
      : doseCondition != null
          ? Tuple2(EvalStatus.sub_standard, 'bad condition')
          : null;
}
