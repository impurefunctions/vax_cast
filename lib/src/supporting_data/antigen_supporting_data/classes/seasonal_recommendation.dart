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
}
