import 'exclusion.dart';

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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['immunityBirthDate'] = immunityBirthDate;
    data['birthCountry'] = birthCountry;
    if (exclusion != null) {
      data['exclusion'] = exclusion.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
