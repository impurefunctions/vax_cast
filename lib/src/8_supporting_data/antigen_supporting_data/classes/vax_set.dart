import '../export_antigen_supporting_data.dart';

class VaxSet {
  String setID;
  String setDescription;
  Null effectiveDate;
  Null cessationDate;
  String conditionLogic;
  List<Condition> condition;

  VaxSet({
    this.setID,
    this.setDescription,
    this.effectiveDate,
    this.cessationDate,
    this.conditionLogic,
    this.condition,
  });

  VaxSet.fromJson(Map<String, dynamic> json) {
    setID = json['setID'];
    setDescription = json['setDescription'];
    effectiveDate = json['effectiveDate'];
    cessationDate = json['cessationDate'];
    conditionLogic = json['conditionLogic'];
    if (json['condition'] != null) {
      condition = <Condition>[];
      json['condition'].forEach((v) {
        condition.add(Condition.fromJson(v));
      });
    }
  }
}
