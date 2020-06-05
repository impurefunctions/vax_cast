import '../export_antigen_supporting_data.dart';

class Interval {
  String fromPrevious;
  String fromTargetDose;
  String fromMostRecent;
  ObservationCode fromRelevantObs;
  String absMinInt;
  String minInt;
  String earliestRecInt;
  String latestRecInt;
  String intervalPriority;
  String effectiveDate;
  String cessationDate;

  Interval({
    this.fromPrevious,
    this.fromTargetDose,
    this.fromMostRecent,
    this.fromRelevantObs,
    this.absMinInt,
    this.minInt,
    this.earliestRecInt,
    this.latestRecInt,
    this.intervalPriority,
    this.effectiveDate,
    this.cessationDate,
  });

  Interval.fromJson(Map<String, dynamic> json) {
    fromPrevious = json['fromPrevious'] as String;
    fromTargetDose = json['fromTargetDose'] as String;
    fromMostRecent = json['fromMostRecent'] as String;
    fromRelevantObs = json['fromRelevantObs'] != null
        ? ObservationCode.fromJson(json['fromRelevantObs'])
        : null;
    absMinInt = json['absMinInt'] as String;
    minInt = json['minInt'] as String;
    earliestRecInt = json['earliestRecInt'] as String;
    latestRecInt = json['latestRecInt'] as String;
    intervalPriority = json['intervalPriority'] as String;
    effectiveDate = json['effectiveDate'] as String;
    cessationDate = json['cessationDate'] as String;
  }
}
