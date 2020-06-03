part of 'a_vax_series.dart';

abstract class ContraindicatedSeries {
  static bool check(
    SeriesStatus status,
    VaxPatient patient,
    String targetDisease,
    SeriesDose seriesDose,
  ) {
    if (status != SeriesStatus.contraindicated) {
      if (patient.conditions != null &&
          SupportingData.antigenSupportingData[targetDisease].contraindications
                  .vaccine !=
              null) {
        for (final condition in patient.conditions) {
          var obsCondition = SupportingData.antigenSupportingData[targetDisease]
              .contraindications.vaccine[condition];
          if (obsCondition != null) {
            var dob = patient.dob;
            var assessmentDate = patient.assessmentDate;
            if (dob.minIfNull(obsCondition.beginAge) <= assessmentDate &&
                assessmentDate < dob.maxIfNull(obsCondition.endAge)) {
              var contraindicatedCvx = <String>[];
              obsCondition.contraindicatedVaccine
                  .forEach((vaccine) => contraindicatedCvx.add(vaccine.cvx));
              seriesDose.preferableVaccine
                  .removeWhere((vax) => contraindicatedCvx.contains(vax.cvx));
            }
          }
          if (seriesDose.preferableVaccine.isEmpty) {
            return true;
          }
        }
      } else
        return false;
    }
    return true;
  }
}
