import '../export_antigen_supporting_data.dart';

class DateOfBirth {
  String immunityBirthDate;
  String birthCountry;
  List<Exclusion> exclusion;

  DateOfBirth({
    this.immunityBirthDate,
    this.birthCountry,
    this.exclusion,
  });

  DateOfBirth.fromJson(Map<String, dynamic> json) {
    immunityBirthDate = json['immunityBirthDate'];
    birthCountry = json['birthCountry'];
    if (json['exclusion'] != null) {
      exclusion = <Exclusion>[];
      json['exclusion'].forEach((v) {
        exclusion.add(Exclusion.fromJson(v));
      });
    }
  }
}
