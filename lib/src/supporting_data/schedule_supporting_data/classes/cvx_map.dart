import 'association.dart';

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

  bool isAgInCvx(String ag) {
    if (association.indexWhere((association) => association.antigen == ag) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }
}
