part of 'a_recommended_dose.dart';

abstract class InadvertentRec {
  static Dose lastInadvertent(pastDoses) {
    int inadvertent = pastDoses.lastIndexWhere(
        (dose) => dose.evaluation.value2 == 'inadvertent administration');
    return inadvertent == -1 ? null : pastDoses[inadvertent];
  }
}
