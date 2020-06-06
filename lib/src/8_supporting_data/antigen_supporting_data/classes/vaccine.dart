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
}
