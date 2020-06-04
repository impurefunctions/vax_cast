import 'package:vax_cast/src/shared.dart';

part 'b_age_rec.dart';
part 'c_intervals_rec.dart';
part 'd_conflict_rec.dart';
part 'e_inadvertent_rec.dart';
part 'f_season_rec.dart';

class RecommendedDose {
  VaxDate earliestDate;
  VaxDate unadjustedRecommendedDate;
  VaxDate unadjustedPastDueDate;
  VaxDate latestDate;
  VaxDate adjustedRecommendedDate;
  VaxDate adjustedPastDueDate;
  String vaccineGuidance;
  String intervalPriority;
  List<Vaccine> recommendedVaccines;

  RecommendedDose();

  void generateForecastDates(
      SeriesDose seriesDose, VaxPatient patient, List<Dose> pastDoses) {
    AgeRec ageRec = AgeRec(patient.dob, seriesDose);

    IntervalRec intervalRec = IntervalRec();
    intervalRec.checkIntervals(
      seriesDose.interval,
      pastDoses,
      patient.pastImmunizations,
    );

    intervalPriority = intervalRec.intervalPriority;

    VaxDate conflict =
        ConflictRec.checkForConflicts(seriesDose, patient.liveVirusList);

    Dose lastInadvertent = InadvertentRec.lastInadvertent(pastDoses);

    //ToDo: intervals from conditions

    earliestDate = LatestOf([
      ageRec.min,
      intervalRec.minIntDate,
      conflict,
      SeasonRec.startDate(seriesDose),
      lastInadvertent?.dateGiven,
    ]);

    unadjustedRecommendedDate =
        ageRec.earliestRec ?? intervalRec.earliestRecIntDate ?? earliestDate;

    unadjustedPastDueDate = ageRec.latestRec != null
        ? ageRec.latestRec.change('- 1 day')
        : intervalRec.latestRecIntDate != null
            ? intervalRec.latestRecIntDate.change('- 1 day')
            : null;

    latestDate = ageRec.max == null ? null : ageRec.max.change('- 1 day');

    adjustedRecommendedDate =
        LatestOf([earliestDate, unadjustedRecommendedDate]);

    adjustedPastDueDate = unadjustedPastDueDate != null
        ? LatestOf([earliestDate, unadjustedPastDueDate])
        : null;

    recommendedVaccines = seriesDose.preferableVaccine;
  }

  void invalidate() {
    earliestDate = null;
    adjustedRecommendedDate = null;
    adjustedPastDueDate = null;
    latestDate = null;
  }
}
