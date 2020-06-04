// part of 'a_dose.dart';

// class Age {
//   List<VaxAge> ageList;
//   Dose previousDose;
//   int targetDose;
//   VaxDate dateGiven;
//   VaxDate dob;
//   bool validAge;
//   AgeReason reason;

//   Age(
//     this.ageList,
//     this.previousDose,
//     this.targetDose,
//     this.dateGiven,
//     this.dob,
//   );

//   Tuple2<bool, AgeReason> givenAtValidAge() {
//     var vaxAge = setDoseAge(ageList);
//     validateAge(vaxAge);
//     return Tuple2(validAge, reason);
//   }

//   VaxAge setDoseAge(List<VaxAge> ageList) => ageList.length == 1
//       ? ageList[0]
//       : dateGiven <= VaxDate.mmddyyyy(ageList[0].cessationDate)
//           ? ageList[0]
//           : ageList[1];

//   void validateAge(VaxAge age) {
//     var absMinAgeDate = dob.minIfNull(age.absMinAge);
//     var minAgeDate = dob.minIfNull(age.minAge);
//     var maxAgeDate = dob.maxIfNull(age.maxAge);
//     dateGiven < absMinAgeDate
//         ? setAgeStatus(false, AgeReason.too_young)
//         : absMinAgeDate <= dateGiven && dateGiven < minAgeDate
//             ? {
//                 previousDose == null
//                     ? setAgeStatus(true, AgeReason.grace_period)
//                     : targetDose == 0
//                         ? setAgeStatus(true, AgeReason.grace_period)
//                         : previousDose.age.value1 &&
//                                 (previousDose.allowInt.value1 ||
//                                     previousDose.prefInt.value1)
//                             ? setAgeStatus(true, AgeReason.grace_period)
//                             : setAgeStatus(false, AgeReason.too_young)
//               }
//             : minAgeDate <= dateGiven && dateGiven < maxAgeDate
//                 ? setAgeStatus(true, AgeReason.valid)
//                 : dateGiven >= maxAgeDate
//                     ? setAgeStatus(false, AgeReason.too_old)
//                     : setAgeStatus(false, AgeReason.cannot_evaluate);
//   }

//   void setAgeStatus(bool valid, AgeReason reason) {
//     validAge = valid;
//     this.reason = reason;
//   }

//   Tuple2<int, TargetStatus> getTarget() =>
//       Tuple2(-1, TargetStatus.not_satisfied);

//   Tuple2<EvalStatus, String> getEvaluation() =>
//       Tuple2(EvalStatus.not_valid, reason.toString());
// }
