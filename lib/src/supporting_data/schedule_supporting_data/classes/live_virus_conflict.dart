class LiveVirusConflict {
  String previousType;
  String previousCvx;
  String currentType;
  String currentCvx;
  String conflictBeginInterval;
  String minConflictEndInterval;
  String conflictEndInterval;

  LiveVirusConflict({
    this.previousType,
    this.previousCvx,
    this.currentType,
    this.currentCvx,
    this.conflictBeginInterval,
    this.minConflictEndInterval,
    this.conflictEndInterval,
  });

  LiveVirusConflict.fromJson(Map<String, dynamic> json) {
    previousType = json['previousType'] as String;
    previousCvx = json['previousCvx'] as String;
    currentType = json['currentType'] as String;
    currentCvx = json['currentCvx'] as String;
    conflictBeginInterval = json['conflictBeginInterval'] as String;
    minConflictEndInterval = json['minConflictEndInterval'] as String;
    conflictEndInterval = json['conflictEndInterval'] as String;
  }
}
