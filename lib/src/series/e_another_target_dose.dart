part of 'a_vax_series.dart';

class AnotherTargetDose {
  SeriesDose seriesDose;
  VaxPatient patient;
  SeriesStatus status;
  bool anotherDose;
  ForecastReason forecastReason;

  AnotherTargetDose(this.seriesDose, this.patient, this.status) {
    anotherDose = false;
  }

  void evaluateAnotherDose(
    List<TargetStatus> targetDoses,
    bool immunity,
    bool antigenContraindicated,
  ) {
    if (!targetDoses.contains(TargetStatus.not_satisfied)) {
      targetDoses.contains(TargetStatus.satisfied)
          ? setRecommendation(
              false, SeriesStatus.complete, ForecastReason.complete)
          : setRecommendation(
              false,
              SeriesStatus.not_recommended,
              ForecastReason.not_recommended_due_to_past_immunizations,
            );
    } else if (status == SeriesStatus.immune || immunity) {
      setRecommendation(
        false,
        SeriesStatus.immune,
        ForecastReason.evidence_of_immunity,
      );
    } else if (status == SeriesStatus.contraindicated ||
        antigenContraindicated) {
      setRecommendation(
        false,
        SeriesStatus.contraindicated,
        ForecastReason.contraindication,
      );
    } else {
      String maxAge;
      if (seriesDose.age.length == 2) {
        if (VaxDate.mmddyyyy(seriesDose.age[1].effectiveDate) >=
            patient.assessmentDate) {
          maxAge = seriesDose.age[1].maxAge;
        }
      }
      maxAge ??= seriesDose.age[0].maxAge;
      if (patient.assessmentDate >= patient.dob.maxIfNull(maxAge)) {
        setRecommendation(
          false,
          SeriesStatus.aged_out,
          ForecastReason.exceeded_maximum_age,
        );
      } else if (seriesDose.seasonalRecommendation == null) {
        setRecommendation(true, SeriesStatus.not_complete, forecastReason);
      } else if (patient.assessmentDate >
          VaxDate.mmddyyyy(seriesDose.seasonalRecommendation.endDate)) {
        setRecommendation(
          false,
          SeriesStatus.not_complete,
          ForecastReason.past_seasonal_recommendation,
        );
      } else {
        setRecommendation(true, SeriesStatus.not_complete, forecastReason);
      }
    }
  }

  void setRecommendation(
    bool another,
    SeriesStatus status,
    ForecastReason reason,
  ) {
    anotherDose = another;
    this.status = status;
    forecastReason = reason;
  }
}
