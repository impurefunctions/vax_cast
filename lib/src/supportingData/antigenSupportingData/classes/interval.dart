import 'observationCode.dart';

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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['fromPrevious'] = fromPrevious;
    data['fromTargetDose'] = fromTargetDose;
    data['fromMostRecent'] = fromMostRecent;
    data['fromRelevantObs'] =
        fromRelevantObs != null ? fromRelevantObs.toJson() : null;
    data['absMinInt'] = absMinInt;
    data['minInt'] = minInt;
    data['earliestRecInt'] = earliestRecInt;
    data['latestRecInt'] = latestRecInt;
    data['intervalPriority'] = intervalPriority;
    data['effectiveDate'] = effectiveDate;
    data['cessationDate'] = cessationDate;
    return data;
  }
}
