import '../export_schedule_supporting_data.dart';

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
}
