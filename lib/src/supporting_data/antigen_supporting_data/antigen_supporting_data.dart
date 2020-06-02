import 'classes/immunity.dart';
import 'classes/contraindications.dart';
import 'classes/series.dart';

export 'classes/clinical_history.dart';
export 'classes/condition.dart';
export 'classes/conditional_skip.dart';
export 'classes/contraindication.dart';
export 'classes/contraindications.dart';
export 'classes/date_of_birth.dart';
export 'classes/exclusion.dart';
export 'classes/immunity.dart';
export 'classes/indication.dart';
export 'classes/interval.dart';
export 'classes/observation_code.dart';
export 'classes/seasonal_recommendation.dart';
export 'classes/series_dose.dart';
export 'classes/series.dart';
export 'classes/vaccine.dart';
export 'classes/vax_age.dart';
export 'classes/vax_set.dart';

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
