import 'vaccine.dart';

class Contraindication {
  String observationTitle;
  String contraindicationText;
  String contraindicationGuidance;
  String beginAge;
  String endAge;
  List<Vaccine> contraindicatedVaccine;

  Contraindication({
    this.observationTitle,
    this.contraindicationText,
    this.contraindicationGuidance,
    this.beginAge,
    this.endAge,
    this.contraindicatedVaccine,
  });

  Contraindication.fromJson(Map<String, dynamic> json) {
    observationTitle = json['observationTitle'];
    contraindicationText = json['contraindicationText'];
    contraindicationGuidance = json['contraindicationGuidance'];
    beginAge = json['beginAge'];
    endAge = json['endAge'];
    if (json['contraindicatedVaccine'] != null) {
      contraindicatedVaccine = <Vaccine>[];
      json['contraindicatedVaccine'].forEach((v) {
        contraindicatedVaccine.add(Vaccine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['observationTitle'] = observationTitle;
    data['contraindicationText'] = contraindicationText;
    data['contraindicationGuidance'] = contraindicationGuidance;
    data['beginAge'] = beginAge;
    data['endAge'] = endAge;
    if (contraindicatedVaccine != null) {
      data['contraindicatedVaccine'] =
          contraindicatedVaccine.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
