import '../export_antigen_supporting_data.dart';

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
}
