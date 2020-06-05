import '../export_antigen_supporting_data.dart';

class Contraindications {
  Map<String, Contraindication> group;
  Map<String, Contraindication> vaccine;

  Contraindications({
    this.group,
    this.vaccine,
  });

  Contraindications.fromJson(Map<String, dynamic> json) {
    if (json['groupContraindication'] != null) {
      group = <String, Contraindication>{};
      json['groupContraindication']
          .forEach((k, v) => group[k] = Contraindication.fromJson(v));
    }
    if (json['vaccineContraindication'] != null) {
      vaccine = <String, Contraindication>{};
      json['vaccineContraindication']
          .forEach((k, v) => vaccine[k] = Contraindication.fromJson(v));
    }
  }
}
