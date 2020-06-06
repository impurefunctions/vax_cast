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
}
