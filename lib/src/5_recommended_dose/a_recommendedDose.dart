import 'package:vax_cast/src/9_shared/shared.dart';

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

  RecommendedDose({
    this.earliestDate,
    this.unadjustedRecommendedDate,
    this.unadjustedPastDueDate,
    this.latestDate,
    this.adjustedRecommendedDate,
    this.adjustedPastDueDate,
    this.vaccineGuidance,
    this.intervalPriority,
    this.recommendedVaccines,
  });

  void generateForecastDates(
      SeriesDose seriesDose, VaxPatient patient, List<Dose> pastDoses) {
    var lastDose = pastDoses == null
        ? null
        : pastDoses.isEmpty
            ? null
            : pastDoses.lastWhere(
                (dose) => dose.evalReason != 'inadvertent administration',
                orElse: () => null);
    var age = seriesDose.age.length == 1
        ? seriesDose.age[0]
        : VaxDate.mmddyyyy(seriesDose.age[0].cessationDate) >=
                patient.assessmentDate
            ? seriesDose.age[0]
            : seriesDose.age[1];
    var maxAgeDate = patient.dob.changeIfNotNull(age.maxAge);
    var latestRecAgeDate = patient.dob.changeIfNotNull(age.latestRecAge);
    var earliestRecAgeDate = patient.dob.changeIfNotNull(age.earliestRecAge);
    var minAgeDate = patient.dob.changeIfNotNull(age.minAge);

    var minIntDate;
    var earliestRecIntDate;
    var latestRecIntDate;

    if (seriesDose.interval != null) {
      for (final interval in seriesDose.interval) {
        intervalPriority = interval.intervalPriority;
        if (interval.fromPrevious == 'Y') {
          if (lastDose != null) {
            var dateGiven = lastDose.dateGiven;
            minIntDate = LatestOf(
                [minIntDate, dateGiven.changeIfNotNull(interval.minInt)]);
            earliestRecIntDate = LatestOf([
              earliestRecIntDate,
              (dateGiven.changeIfNotNull(interval.earliestRecInt))
            ]);
            latestRecIntDate = LatestOf([
              latestRecIntDate,
              (dateGiven.changeIfNotNull(interval.latestRecInt))
            ]);
          }
        } else if (interval.fromTargetDose != null) {
          var prevDose = pastDoses.firstWhere(
              (dose) =>
                  dose.target.value1 == int.parse(interval.fromTargetDose) - 1,
              orElse: () => null);
          if (prevDose != null) {
            minIntDate = LatestOf([
              minIntDate,
              prevDose.dateGiven.changeIfNotNull(interval.minInt)
            ]);
            earliestRecIntDate = LatestOf([
              earliestRecIntDate,
              prevDose.dateGiven.changeIfNotNull(interval.earliestRecInt)
            ]);
            latestRecIntDate = LatestOf([
              latestRecIntDate,
              (prevDose.dateGiven.changeIfNotNull(interval.latestRecInt))
            ]);
          }
        } else if (interval.fromMostRecent != null) {
          var pastCvx = interval.fromMostRecent.split(';');
          var indexDose = patient.pastImmunizations.lastWhere(
              (dose) => pastCvx.contains(dose.cvx),
              orElse: () => null);
          if (indexDose != null) {
            minIntDate = LatestOf([
              minIntDate,
              indexDose.dateGiven.changeIfNotNull(interval.minInt)
            ]);
            earliestRecIntDate = LatestOf([
              earliestRecIntDate,
              indexDose.dateGiven.changeIfNotNull(interval.earliestRecInt)
            ]);
            latestRecIntDate = LatestOf([
              latestRecIntDate,
              indexDose.dateGiven.changeIfNotNull(interval.latestRecInt)
            ]);
          }
        }
      }
    }

    var conflictCvx = <String>[];
    if (seriesDose.allowableVaccine != null) {
      seriesDose.allowableVaccine.forEach((dose) {
        if (!conflictCvx.contains(dose.cvx)) conflictCvx.add(dose.cvx);
      });
    }
    if (seriesDose.preferableVaccine != null) {
      seriesDose.preferableVaccine.forEach((dose) {
        if (!conflictCvx.contains(dose.cvx)) conflictCvx.add(dose.cvx);
      });
    }
    var latestConflictEndIntDate = <VaxDate>[];
    for (final liveDose in patient.liveVirusList) {
      for (final conflict
          in SupportingData.scheduleSupportingData.liveVirusConflicts) {
        if (conflict.previousCvx == liveDose.cvx &&
            conflictCvx.contains(conflict.currentCvx)) {
          latestConflictEndIntDate.add(liveDose.dateGiven
              .changeIfNotNull(conflict.minConflictEndInterval));
        }
      }
    }

    var inadvertent = pastDoses.lastIndexWhere(
        (dose) => dose.evalReason == 'inadvertent administration');
    var lastInadvertentDose = inadvertent == -1 ? null : pastDoses[inadvertent];

    var seasonRecStartDate = seriesDose.seasonalRecommendation != null
        ? VaxDate.mmddyyyy(seriesDose.seasonalRecommendation.startDate)
        : VaxDate.min();

    //ToDo: intervals from conditions

    earliestDate = LatestOf([
      minAgeDate,
      minIntDate,
      LatestOf(latestConflictEndIntDate),
      seasonRecStartDate,
      lastInadvertentDose?.dateGiven,
    ]);

    unadjustedRecommendedDate =
        earliestRecAgeDate ?? earliestRecIntDate ?? earliestDate;
    unadjustedPastDueDate = latestRecAgeDate != null
        ? latestRecAgeDate.change('- 1 day')
        : latestRecIntDate != null ? latestRecIntDate.change('- 1 day') : null;
    latestDate = maxAgeDate == null ? null : maxAgeDate.change('- 1 day');
    adjustedRecommendedDate =
        LatestOf([earliestDate, unadjustedRecommendedDate]);
    adjustedPastDueDate = unadjustedPastDueDate != null
        ? LatestOf([earliestDate, unadjustedPastDueDate])
        : null;

    recommendedVaccines = <Vaccine>[];
    recommendedVaccines = seriesDose.preferableVaccine;
  }

  void invalidate() {
    earliestDate = null;
    adjustedRecommendedDate = null;
    adjustedPastDueDate = null;
    latestDate = null;
  }
}
