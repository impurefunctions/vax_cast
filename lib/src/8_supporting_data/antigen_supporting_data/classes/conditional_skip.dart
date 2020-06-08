import '../export_antigen_supporting_data.dart';

class ConditionalSkip {
  String context;
  String setLogic;
  List<VaxSet> vaxSet;

  ConditionalSkip({
    this.context,
    this.setLogic,
    this.vaxSet,
  });

  ConditionalSkip.fromJson(Map<String, dynamic> json) {
    context = json['context'];
    setLogic = json['setLogic'];
    if (json['set'] != null) {
      vaxSet = <VaxSet>[];
      json['set'].forEach((v) {
        vaxSet.add(VaxSet.fromJson(v));
      });
    }
  }
}
