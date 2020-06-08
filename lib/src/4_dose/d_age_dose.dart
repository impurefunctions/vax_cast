part of 'a_dose.dart';

Tuple2<bool, String> setAgeStatus(List<VaxAge> ageList, Dose pastDose,
        int targetDose, VaxDate dateGiven, VaxDate dob) =>
    validateAge(
        setDoseAge(ageList, dateGiven), pastDose, targetDose, dateGiven, dob);

VaxAge setDoseAge(List<VaxAge> ageList, VaxDate dateGiven) {
  for (var age in ageList) {
    if (age.effectiveDate == null && age.cessationDate == null) {
      return age;
    }
    if (age.effectiveDate != null && age.cessationDate == null) {
      if (VaxDate.mmddyyyy(age.effectiveDate) <= dateGiven) {
        return age;
      }
    } else if (age.cessationDate != null && age.effectiveDate == null) {
      if (dateGiven < VaxDate.mmddyyyy(age.cessationDate)) {
        return age;
      }
    } else if (dateGiven < VaxDate.mmddyyyy(age.cessationDate) &&
        VaxDate.mmddyyyy(age.effectiveDate) <= dateGiven) {
      return age;
    }
  }
  return ageList[0];
}

Tuple2<bool, String> validateAge(
    VaxAge age, Dose pastDose, int targetDose, VaxDate dateGiven, VaxDate dob) {
  var absMinAgeDate = dob.minIfNull(age.absMinAge);
  var minAgeDate = dob.minIfNull(age.minAge);
  var maxAgeDate = dob.maxIfNull(age.maxAge);
  if (dateGiven < absMinAgeDate) {
    return Tuple2(false, 'too young');
  } else if (absMinAgeDate <= dateGiven && dateGiven < minAgeDate) {
    if (pastDose == null) {
      return Tuple2(true, 'grace period');
    } else if (targetDose == 0) {
      return Tuple2(true, 'grace period');
    } else if ((pastDose?.validAge?.value1 ?? true) &&
        ((pastDose?.allowInt?.value1 ?? true) ||
            (pastDose?.prefInt?.value1 ?? true))) {
      return Tuple2(true, 'grace period');
    } else {
      return Tuple2(false, 'too young');
    }
  } else if (minAgeDate <= dateGiven && dateGiven < maxAgeDate) {
    return Tuple2(true, 'valid age');
  } else if (dateGiven >= maxAgeDate) {
    return Tuple2(false, 'too old');
  } else {
    return Tuple2(false, 'unable to evaluate date');
  }
}
