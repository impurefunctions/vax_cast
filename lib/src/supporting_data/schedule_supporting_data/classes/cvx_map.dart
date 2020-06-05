import '../export_schedule_supporting_data.dart';

class CvxMap {
  String shortDescription;
  List<Association> association;

  CvxMap({
    this.shortDescription,
    this.association,
  });

  CvxMap.fromJson(Map<String, dynamic> json) {
    shortDescription = json['shortDescription'];
    if (json['association'] != null) {
      association = <Association>[];
      json['association'].forEach((v) {
        association.add(Association.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['shortDescription'] = shortDescription;
    if (association != null) {
      data['association'] = association.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool isAgInCvx(String ag) {
    if (association.indexWhere((association) => association.antigen == ag) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }
}
