import 'package:vax_cast/src/9_shared/shared.dart';

part 'b_is_relevant.dart';

class Forecast {
  Map<String, Antigen> antigens;
  List<GroupForecast> groupForecast;
  VaxPatient patient;

  Forecast() {
    antigens = <String, Antigen>{};
  }

  Future<List<GroupForecast>> cast(version, bundles, patient, immunizations,
      recommendations, conditions, allergyInterolerance) async {
    await SupportingData.load();
    this.patient = VaxPatient.fromFhir(
      version,
      bundles,
      patient,
      immunizations,
      recommendations,
      conditions,
    );
    prepareAntigens();
    getForecast();
    return groupForecast;
  }

  void prepareAntigens() {
    SupportingData.antigenSupportingData.forEach((ag, seriesGroup) {
      antigens[ag] = Antigen(patient, ag);
      for (var series in seriesGroup.series) {
        if (isRelevant(series, patient)) antigens[ag].newSeries(series);
      }
      loadScheduleSupportingData(ag);
    });
    antigens.removeWhere((ag, antigen) => antigen.groups == null);
  }

  void loadScheduleSupportingData(String ag) {
    for (final dose in patient.pastImmunizations) {
      if (isAgInCvx(dose.cvx, ag)) {
        for (final group in antigens[ag].groups) {
          for (final series in group.vaxSeries) {
            series.pastDoses.add(Dose.copy(dose));
          }
        }
      }
    }
  }

  bool isAgInCvx(String cvx, String ag) =>
      SupportingData.scheduleSupportingData.cvxToAntigenMap[cvx].association
                  .indexWhere((association) => association.antigen == ag) ==
              -1
          ? false
          : true;

  void getForecast() {
//remove after testing ******************************************************//
    antigens.removeWhere(
        (ag, antigen) => antigen.seriesVaccineGroup != patient.seriesGroup);
// ***************************************************************************//
    antigens.forEach((ag, antigen) => antigen.getForecast());
    groupForecast = <GroupForecast>[];
    antigens.forEach((ag, antigen) => identifyAndEvaluateVaccineGroup(antigen));
    groupForecast.forEach((forecast) => forecast.convertNull());
  }

  void identifyAndEvaluateVaccineGroup(Antigen antigen) {
    antigen.groups.forEach((seriesGroup) {
      if (antigen.isSingleAgVaxGroup()) {
        groupForecast.add(GroupForecast.singleAg(seriesGroup.vaxSeries[0]));
      } else {
        var alreadyIncluded = false;
        for (final forecast in groupForecast) {
          alreadyIncluded = alreadyIncluded ||
              forecast.seriesVaccineGroup == antigen.seriesVaccineGroup;
        }
        if (!alreadyIncluded) {
          var newGroupForecast = GroupForecast();
          var incomplete = false;
          var immune = true;
          var contraindication = false;
          for (final ag in antigens.keys) {
            if (antigens[ag].seriesVaccineGroup == antigen.seriesVaccineGroup) {
              for (final series in antigens[ag].groups) {
                var curSeries = series.vaxSeries[0];
                incomplete =
                    incomplete || curSeries.seriesStatus == 'not complete';
                immune = immune && curSeries.seriesStatus == 'immune';
                contraindication = contraindication ||
                    curSeries.seriesStatus == 'contraindicated';
                newGroupForecast.applyMultiAgLogic(curSeries);
              }
            }
          }
          newGroupForecast.finalDates();
          if (immune) {
            newGroupForecast.groupStatus = 'immune';
          } else if (contraindication) {
            newGroupForecast.groupStatus = 'contraindicated';
          } else if (incomplete) {
            newGroupForecast.groupStatus = 'not complete';
          } else {
            newGroupForecast.groupStatus = 'complete';
          }
          newGroupForecast.seriesVaccineGroup = antigen.seriesVaccineGroup;
          groupForecast.add(newGroupForecast);
        }
      }
    });
  }
}
