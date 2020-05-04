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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['guidelineCode'] = guidelineCode;
    data['guidelineTitle'] = guidelineTitle;
    return data;
  }
}
