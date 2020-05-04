class VaxAge {
  String absMinAge;
  String minAge;
  String earliestRecAge;
  String latestRecAge;
  String maxAge;
  String effectiveDate;
  String cessationDate;

  VaxAge({
    this.absMinAge,
    this.minAge,
    this.earliestRecAge,
    this.latestRecAge,
    this.maxAge,
    this.effectiveDate,
    this.cessationDate,
  });

  VaxAge.fromJson(Map<String, dynamic> json) {
    absMinAge = json['absMinAge'];
    minAge = json['minAge'];
    earliestRecAge = json['earliestRecAge'];
    latestRecAge = json['latestRecAge'];
    maxAge = json['maxAge'];
    effectiveDate = json['effectiveDate'];
    cessationDate = json['cessationDate'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['absMinAge'] = absMinAge;
    data['minAge'] = minAge;
    data['earliestRecAge'] = earliestRecAge;
    data['latestRecAge'] = latestRecAge;
    data['maxAge'] = maxAge;
    data['effectiveDate'] = effectiveDate;
    data['cessationDate'] = cessationDate;
    return data;
  }
}
