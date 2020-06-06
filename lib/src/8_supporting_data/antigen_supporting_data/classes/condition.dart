class Condition {
  String conditionID;
  String conditionType;
  String startDate;
  String endDate;
  String beginAge;
  String endAge;
  String interval;
  String doseCount;
  String doseType;
  String doseCountLogic;
  String vaccineTypes;
  String seriesGroups;

  Condition({
    this.conditionID,
    this.conditionType,
    this.startDate,
    this.endDate,
    this.beginAge,
    this.endAge,
    this.interval,
    this.doseCount,
    this.doseType,
    this.doseCountLogic,
    this.vaccineTypes,
    this.seriesGroups,
  });

  Condition.fromJson(Map<String, dynamic> json) {
    conditionID = json['conditionID'];
    conditionType = json['conditionType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    beginAge = json['beginAge'];
    endAge = json['endAge'];
    interval = json['interval'];
    doseCount = json['doseCount'];
    doseType = json['doseType'];
    doseCountLogic = json['doseCountLogic'];
    vaccineTypes = json['vaccineTypes'];
    seriesGroups = json['seriesGroups'];
  }
}
