part of 'a_dose.dart';

class Inadvertent {
  bool isInadvertentDose(SeriesDose seriesDose, String cvx) =>
      seriesDose.inadvertentVaccine == null
          ? false
          : seriesDose.inadvertentVaccine
                  .indexWhere((vaccine) => vaccine.cvx == cvx) !=
              -1;

  Tuple2<int, TargetStatus> getTarget() =>
      Tuple2(-1, TargetStatus.not_satisfied);

  Tuple2<EvalStatus, String> getEvaluation() =>
      Tuple2(EvalStatus.not_valid, 'inadvertent administration');
}
