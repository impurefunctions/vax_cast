class SeasonalRecommendation {
  String startDate;
  String endDate;

  SeasonalRecommendation({
    this.startDate,
    this.endDate,
  });

  SeasonalRecommendation.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
