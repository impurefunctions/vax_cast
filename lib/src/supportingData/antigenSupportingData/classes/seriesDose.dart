import 'vaxAge.dart';
import 'interval.dart';
import 'vaccine.dart';
import 'conditionalSkip.dart';
import 'seasonalRecommendation.dart';

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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['doseNumber'] = doseNumber;
    data['age'] = age != null ? age.map((v) => v.toJson()).toList() : null;
    data['interval'] =
        interval != null ? interval.map((v) => v.toJson()).toList() : null;
    data['allowableInterval'] =
        allowableInterval != null ? allowableInterval.toJson() : null;
    data['preferableVaccine'] = preferableVaccine != null
        ? preferableVaccine.map((v) => v.toJson()).toList()
        : null;
    data['allowableVaccine'] = allowableVaccine != null
        ? allowableVaccine.map((v) => v.toJson()).toList()
        : null;
    data['inadvertentVaccine'] = inadvertentVaccine != null
        ? inadvertentVaccine.map((v) => v.toJson()).toList()
        : null;
    data['conditionalSkip'] = conditionalSkip != null
        ? conditionalSkip.map((v) => v.toJson()).toList()
        : null;
    data['recurringDose'] = recurringDose;
    data['seasonalRecommendation'] =
        seasonalRecommendation != null ? seasonalRecommendation.toJson() : null;
    return data;
  }

  bool isInadvertentDose(String cvx) => inadvertentVaccine == null
      ? false
      : inadvertentVaccine.indexWhere((vaccine) => vaccine.cvx == cvx) == -1
          ? false
          : true;
}
