import 'condition.dart';

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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['setID'] = setID;
    data['setDescription'] = setDescription;
    data['effectiveDate'] = effectiveDate;
    data['cessationDate'] = cessationDate;
    data['conditionLogic'] = conditionLogic;
    if (condition != null) {
      data['condition'] = condition.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
