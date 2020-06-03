part of 'a_dose.dart';

abstract class Inadvertent {
  static bool isInadvertentDose(SeriesDose seriesDose, String cvx) =>
      seriesDose.inadvertentVaccine == null
          ? false
          : seriesDose.inadvertentVaccine
                  .indexWhere((vaccine) => vaccine.cvx == cvx) !=
              -1;

  static Tuple2<int, TargetStatus> getTarget() =>
      Tuple2(-1, TargetStatus.not_satisfied);

  static Tuple2<EvalStatus, String> getEvaluation() =>
      Tuple2(EvalStatus.not_valid, 'inadvertent administration');
}
