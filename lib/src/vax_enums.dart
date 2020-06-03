enum VaxGender {
  female,
  male,
  unknown,
}

enum FHIR_V {
  r4,
  stu3,
  dstu2,
}

enum SeriesStatus {
  aged_out,
  complete,
  contraindicated,
  immune,
  not_complete,
  not_recommended,
}

enum TargetStatus {
  not_satisfied,
  satisfied,
  skipped,
}

enum EvalStatus {
  extraneous,
  not_valid,
  sub_standard,
  valid,
  skipped,
}

enum Context {
  evaluation,
  forecast,
}

enum AgeReason {
  too_young,
  grace_period,
  too_old,
  valid,
  cannot_evaluate,
}

enum IntReason {
  too_soon,
  grace_period,
  preferable,
  allowable,
}

enum VaxReason {
  preferable,
  less_than_recommended_volume,
  not_preferable,
  out_of_age_range,
  wrong_trade_name,
  none_specified,
  allowable,
  not_allowable,
}

enum ForecastReason {
  not_recommended_due_to_past_immunizations,
  evidence_of_immunity,
  contraindication,
  exceeded_maximum_age,
  past_seasonal_recommendation,
  complete,
}
