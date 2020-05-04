class Association {
  String antigen;
  String associationBeginAge;
  String associationEndAge;

  Association({
    this.antigen,
    this.associationBeginAge,
    this.associationEndAge,
  });

  Association.fromJson(Map<String, dynamic> json) {
    antigen = json['antigen'];
    associationBeginAge = json['associationBeginAge'];
    associationEndAge = json['associationEndAge'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['antigen'] = antigen;
    data['associationBeginAge'] = associationBeginAge;
    data['associationEndAge'] = associationEndAge;
    return data;
  }
}
