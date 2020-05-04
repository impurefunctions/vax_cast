class Vaccine {
  String vaccineType;
  String cvx;
  String beginAge;
  String endAge;
  String tradeName;
  String mvx;
  String volume;
  String forecastVaccineType;

  Vaccine({
    this.vaccineType,
    this.cvx,
    this.beginAge,
    this.endAge,
    this.tradeName,
    this.mvx,
    this.volume,
    this.forecastVaccineType,
  });

  Vaccine.fromJson(Map<String, dynamic> json) {
    vaccineType = json['vaccineType'] as String;
    cvx = json['cvx'] as String;
    beginAge = json['beginAge'] as String;
    endAge = json['endAge'] as String;
    tradeName = json['tradeName'] as String;
    mvx = json['mvx'] as String;
    volume = json['volume'] as String;
    forecastVaccineType = json['forecastVaccineType'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['vaccineType'] = vaccineType;
    data['cvx'] = cvx;
    data['beginAge'] = beginAge;
    data['endAge'] = endAge;
    data['tradeName'] = tradeName;
    data['mvx'] = mvx;
    data['volume'] = volume;
    data['forecastVaccineType'] = forecastVaccineType;
    return data;
  }
}
