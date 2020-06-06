import '../export_antigen_supporting_data.dart';

class SeriesDose {
  int doseNumber;
  List<VaxAge> age;
  List<Interval> interval;
  Interval allowableInterval;
  List<Vaccine> preferableVaccine;
  List<Vaccine> allowableVaccine;
  List<Vaccine> inadvertentVaccine;
  List<ConditionalSkip> conditionalSkip;
  String recurringDose;
  SeasonalRecommendation seasonalRecommendation;

  SeriesDose({
    this.doseNumber,
    this.age,
    this.interval,
    this.allowableInterval,
    this.preferableVaccine,
    this.allowableVaccine,
    this.inadvertentVaccine,
    this.conditionalSkip,
    this.recurringDose,
    this.seasonalRecommendation,
  });

  SeriesDose.fromJson(Map<String, dynamic> json) {
    doseNumber = json['doseNumber'];
    if (json['age'] != null) {
      age = <VaxAge>[];
      json['age'].forEach((v) {
        age.add(VaxAge.fromJson(v));
      });
    }
    if (json['interval'] != null) {
      interval = <Interval>[];
      json['interval'].forEach((v) {
        interval.add(Interval.fromJson(v));
      });
    }
    allowableInterval = json['allowableInterval'] != null
        ? Interval.fromJson(json['allowableInterval'])
        : null;
    if (json['preferableVaccine'] != null) {
      preferableVaccine = <Vaccine>[];
      json['preferableVaccine'].forEach((v) {
        preferableVaccine.add(Vaccine.fromJson(v));
      });
    }
    if (json['allowableVaccine'] != null) {
      allowableVaccine = <Vaccine>[];
      json['allowableVaccine'].forEach((v) {
        allowableVaccine.add(Vaccine.fromJson(v));
      });
    }
    if (json['inadvertentVaccine'] != null) {
      inadvertentVaccine = <Vaccine>[];
      json['inadvertentVaccine'].forEach((v) {
        inadvertentVaccine.add(Vaccine.fromJson(v));
      });
    }
    if (json['conditionalSkip'] != null) {
      conditionalSkip = <ConditionalSkip>[];
      json['conditionalSkip'].forEach((v) {
        conditionalSkip.add(ConditionalSkip.fromJson(v));
      });
    }
    recurringDose = json['recurringDose'];
    seasonalRecommendation = json['seasonalRecommendation'] != null
        ? SeasonalRecommendation.fromJson(json['seasonalRecommendation'])
        : null;
  }
}
