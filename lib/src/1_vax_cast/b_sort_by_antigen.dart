part of 'a_vax_cast.dart';

Map<Dz, Antigen> sortByAntigen(VaxPatient patient) {
  Map<Dz, Antigen> ag = <Dz, Antigen>{};
  for (final vaccine in patient.pastImmunizations) {
    for (final association in SupportingData
        .scheduleSupportingData.cvxToAntigenMap[vaccine.cvx].association) {
      if (datesApply(patient.dob, vaccine.dateGiven,
          association.associationBeginAge, association.associationEndAge)) {
        ag.keys.contains(Dz.parse(association.antigen))
            ? ag[Dz.parse(association.antigen)].pastDoses.add(vaccine)
            : ag[Dz.parse(association.antigen)] =
                Antigen(pastDoses: <Dose>[vaccine]);
      }
    }
  }
  return ag;
}

bool datesApply(
        VaxDate dob, VaxDate compareDate, String startAge, String endAge) =>
    dob.minIfNull(startAge) <= compareDate &&
    compareDate < dob.maxIfNull(endAge);
