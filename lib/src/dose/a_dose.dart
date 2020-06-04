import 'package:dartz/dartz.dart';

import '../shared.dart';

class Dose {
  VaxDate dateGiven;
  VaxDate lotExp;
  String doseCondition;
  String cvx;
  String mvx;
  int vol;

  Dose({
    this.dateGiven,
    this.cvx,
    this.mvx,
  });
}
