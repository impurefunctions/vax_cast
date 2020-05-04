class ObservationCode {
  String text;
  String code;

  ObservationCode({
    this.text,
    this.code,
  });

  ObservationCode.fromJson(Map<String, dynamic> json) {
    text = json['text'] as String;
    code = json['code'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['text'] = text;
    data['code'] = code;
    return data;
  }
}
