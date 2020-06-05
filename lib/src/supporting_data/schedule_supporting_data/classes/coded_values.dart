class CodedValues {
  String code;
  String codeSystem;
  String text;

  CodedValues({
    this.code,
    this.codeSystem,
    this.text,
  });

  CodedValues.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    codeSystem = json['codeSystem'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['code'] = code;
    data['codeSystem'] = codeSystem;
    data['text'] = text;
    return data;
  }
}
