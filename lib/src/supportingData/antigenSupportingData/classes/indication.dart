class Indication {
  String text;
  String description;
  String beginAge;
  String endAge;
  String guidance;

  Indication({
    this.text,
    this.description,
    this.beginAge,
    this.endAge,
    this.guidance,
  });

  Indication.fromJson(Map<String, dynamic> json) {
    text = json['text'] as String;
    description = json['description'] as String;
    beginAge = json['beginAge'] as String;
    endAge = json['endAge'] as String;
    guidance = json['guidance'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['text'] = text;
    data['description'] = description;
    data['beginAge'] = beginAge;
    data['endAge'] = endAge;
    data['guidance'] = guidance;
    return data;
  }
}
