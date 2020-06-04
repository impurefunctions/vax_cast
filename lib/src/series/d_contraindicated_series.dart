part of 'a_vax_series.dart';

abstract class ContraindicatedSeries {
  static bool check(
    SeriesStatus status,
    VaxPatient patient,
    String targetDisease,
    SeriesDose seriesDose,
  ) {
    bool contraindicated = false;
    if (status != SeriesStatus.contraindicated) {
      if (patient.conditions != null &&
          SupportingData.antigenSupportingData[targetDisease].contraindications
                  .vaccine !=
              null) {
        for (final condition in patient.conditions) {
          Contraindication obsCondition = SupportingData
              .antigenSupportingData[targetDisease]
              .contraindications
              .vaccine[condition];
          if (obsCondition != null) {
            VaxDate dob = patient.dob;
            VaxDate assessmentDate = patient.assessmentDate;
            if (dob.minIfNull(obsCondition.beginAge) <= assessmentDate &&
                assessmentDate < dob.maxIfNull(obsCondition.endAge)) {
              List<String> contraindicatedCvx = <String>[];
              obsCondition.contraindicatedVaccine
                  .forEach((vaccine) => contraindicatedCvx.add(vaccine.cvx));
              seriesDose.preferableVaccine
                  .removeWhere((vax) => contraindicatedCvx.contains(vax.cvx));
            }
          }
          if (seriesDose.preferableVaccine.isEmpty) {
            contraindicated = true;
          }
        }
      } else {
        contraindicated = false;
      }
    } else {
      contraindicated = true;
    }
    return contraindicated;
  }
}
