import 'clinicalHistory.dart';
import 'dateOfBirth.dart';

class Immunity {
  List<ClinicalHistory> clinicalHistory;
  DateOfBirth dateOfBirth;

  Immunity({
    this.clinicalHistory,
    this.dateOfBirth,
  });

  Immunity.fromJson(Map<String, dynamic> json) {
    if (json['clinicalHistory'] != null) {
      clinicalHistory = <ClinicalHistory>[];
      json['clinicalHistory'].forEach((v) {
        clinicalHistory.add(ClinicalHistory.fromJson(v));
      });
    }
    dateOfBirth = json['dateOfBirth'] != null
        ? DateOfBirth.fromJson(json['dateOfBirth'])
        : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (clinicalHistory != null) {
      data['clinicalHistory'] = clinicalHistory.map((v) => v.toJson()).toList();
    }
    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth.toJson();
    }
    return data;
  }
}
