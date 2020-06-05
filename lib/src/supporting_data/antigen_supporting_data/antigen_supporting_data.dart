import 'classes/immunity.dart';
import 'classes/contraindications.dart';
import 'classes/series.dart';

class AntigenSupportingData {
  Immunity immunity;
  Contraindications contraindications;
  List<Series> series;

  AntigenSupportingData({
    this.immunity,
    this.contraindications,
    this.series,
  });

  AntigenSupportingData.fromJson(Map<String, dynamic> json) {
    immunity =
        json['immunity'] != null ? Immunity.fromJson(json['immunity']) : null;
    contraindications = json['contraindications'] != null
        ? Contraindications.fromJson(json['contraindications'])
        : null;
    if (json['series'] != null) {
      series = <Series>[];
      json['series'].forEach((v) {
        series.add(Series.fromJson(v));
      });
    }
  }
}
