part of 'a_dose.dart';

abstract class Season {
  static bool givenOutsideSeason(
          SeasonalRecommendation recommendation, VaxDate dateGiven) =>
      recommendation == null
          ? false
          : VaxDate.max().fromNullableString(recommendation.endDate) <=
                  dateGiven ||
              dateGiven <
                  VaxDate.min().fromNullableString(recommendation.startDate);

  static Tuple2<int, TargetStatus> getTarget() =>
      Tuple2(-1, TargetStatus.not_satisfied);

  static Tuple2<EvalStatus, String> getEvaluation() =>
      Tuple2(EvalStatus.valid, 'given outside seasonal recommendation');
}
