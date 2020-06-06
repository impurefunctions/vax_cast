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
}
