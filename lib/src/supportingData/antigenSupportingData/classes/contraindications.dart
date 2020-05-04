import 'contraindication.dart';

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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (group != null) {
      data['groupContraindication'] = <String, dynamic>{};
      group.forEach((k, v) => data['groupContraindication'][k] = v.toJson());
    }
    if (vaccine != null) {
      data['vaccineContraindication'] = <String, dynamic>{};
      vaccine
          .forEach((k, v) => data['vaccineContraindication'][k] = v.toJson());
    }
    return data;
  }
}
