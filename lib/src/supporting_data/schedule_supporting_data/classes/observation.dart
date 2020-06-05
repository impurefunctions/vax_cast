import 'codedValues.dart';

class Observation {
  String observationCode;
  String observationTitle;
  Null group;
  String indicationText;
  String contraindicationText;
  String clarifyingText;
  List<CodedValues> codedValues;

  Observation({
    this.observationCode,
    this.observationTitle,
    this.group,
    this.indicationText,
    this.contraindicationText,
    this.clarifyingText,
    this.codedValues,
  });

  Observation.fromJson(Map<String, dynamic> json) {
    observationCode = json['observationCode'];
    observationTitle = json['observationTitle'];
    group = json['group'];
    indicationText = json['indicationText'];
    contraindicationText = json['contraindicationText'];
    clarifyingText = json['clarifyingText'];
    if (json['codedValues'] != null) {
      codedValues = <CodedValues>[];
      json['codedValues'].forEach((v) {
        codedValues.add(CodedValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['observationCode'] = observationCode;
    data['observationTitle'] = observationTitle;
    data['group'] = group;
    data['indicationText'] = indicationText;
    data['contraindicationText'] = contraindicationText;
    data['clarifyingText'] = clarifyingText;
    if (codedValues != null) {
      data['codedValues'] = codedValues.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
