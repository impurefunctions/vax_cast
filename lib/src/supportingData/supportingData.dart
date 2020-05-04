import 'dart:convert';
import 'dart:io';

import 'antigenSupportingData/antigenSupportingData.dart';
import 'scheduleSupportingData/scheduleSupportingData.dart';

class SupportingData {
  static Map<String, AntigenSupportingData> _antigenSupportingData;
  static ScheduleSupportingData _scheduleSupportingData;

  SupportingData._();

  static Map<String, AntigenSupportingData> get antigenSupportingData =>
      _antigenSupportingData;
  static ScheduleSupportingData get scheduleSupportingData =>
      _scheduleSupportingData;
  static bool isAgInCvx(String cvx, String ag) =>
      _scheduleSupportingData.isAgInCvx(cvx, ag);
  static Map<String, dynamic> get toJson => _toJson();
  static Future<void> load() => _load();

  static Future<void> _load() async {
    await _getSupportingData();
  }

  static void _getSupportingData() async {
    var json = jsonDecode(
        await File('lib/infrastructure/supportingData/supportingData.json')
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

  static Map<String, dynamic> _toJson() {
    var data = <String, dynamic>{};
    if (_antigenSupportingData != null) {
      data['antigenSupportingData'] = <String, dynamic>{};
      _antigenSupportingData
          .forEach((k, v) => data['antigenSupportingData'][k] = v.toJson());
    }
    if (_scheduleSupportingData != null) {
      data['scheduleSupportingData'] = _scheduleSupportingData.toJson();
    }
    return data;
  }
}
