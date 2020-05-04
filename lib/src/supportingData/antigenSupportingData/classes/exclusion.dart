class Exclusion {
  String exclusionCode;
  String exclusionTitle;

  Exclusion({
    this.exclusionCode,
    this.exclusionTitle,
  });

  Exclusion.fromJson(Map<String, dynamic> json) {
    exclusionCode = json['exclusionCode'];
    exclusionTitle = json['exclusionTitle'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['exclusionCode'] = exclusionCode;
    data['exclusionTitle'] = exclusionTitle;
    return data;
  }
}
