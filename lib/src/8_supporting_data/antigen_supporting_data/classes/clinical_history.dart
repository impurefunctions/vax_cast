class ClinicalHistory {
  String guidelineCode;
  String guidelineTitle;

  ClinicalHistory({
    this.guidelineCode,
    this.guidelineTitle,
  });

  ClinicalHistory.fromJson(Map<String, dynamic> json) {
    guidelineCode = json['guidelineCode'];
    guidelineTitle = json['guidelineTitle'];
  }
}
