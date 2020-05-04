import 'vaxSet.dart';

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

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['context'] = context;
    data['setLogic'] = setLogic;
    if (vaxSet != null) {
      data['set'] = vaxSet.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool correctContext(String compareContext) =>
      (context == 'Both' || context == compareContext);
}
