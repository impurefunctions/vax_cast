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
}
