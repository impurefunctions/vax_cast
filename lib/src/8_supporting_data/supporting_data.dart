import 'dart:convert';
import 'dart:io';

import 'antigen_supporting_data/antigen_supporting_data.dart';
import 'schedule_supporting_data/schedule_supporting_data.dart';

class SupportingData {
  static Map<String, AntigenSupportingData> _antigenSupportingData;
  static ScheduleSupportingData _scheduleSupportingData;

  SupportingData._();

  static Map<String, AntigenSupportingData> get antigenSupportingData =>
      _antigenSupportingData;
  static ScheduleSupportingData get scheduleSupportingData =>
      _scheduleSupportingData;
  static Future<void> load() => _load();

  static Future<void> _load() async {
    await _getSupportingData();
  }

  static void _getSupportingData() async {
    var json = jsonDecode(
        await File('lib/src/supporting_data/supporting_data.json')
            .readAsString());
    if (json['antigenSupportingData'] != null) {
      _antigenSupportingData = <String, AntigenSupportingData>{};
      json['antigenSupportingData'].forEach((k, v) {
        antigenSupportingData[k] = AntigenSupportingData.fromJson(v);
      });
    }
    _scheduleSupportingData = json['scheduleSupportingData'] != null
        ? ScheduleSupportingData.fromJson(json['scheduleSupportingData'])
        : null;
  }
}
