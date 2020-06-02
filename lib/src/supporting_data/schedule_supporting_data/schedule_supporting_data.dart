import 'classes/cvx_map.dart';
import 'classes/live_virus_conflict.dart';
import 'classes/observation.dart';
import 'classes/series_vaccine_group.dart';

export 'classes/association.dart';
export 'classes/coded_values.dart';
export 'classes/cvx_map.dart';
export 'classes/live_virus_conflict.dart';
export 'classes/observation.dart';
export 'classes/series_vaccine_group.dart';

class ScheduleSupportingData {
  List<LiveVirusConflict> liveVirusConflicts;
  Map<String, SeriesVaccineGroup> seriesVaccineGroups;
  Map<String, CvxMap> cvxToAntigenMap;
  Map<String, Observation> observations;

  ScheduleSupportingData({
    this.liveVirusConflicts,
    this.seriesVaccineGroups,
    this.cvxToAntigenMap,
    this.observations,
  });

  ScheduleSupportingData.fromJson(Map<String, dynamic> json) {
    if (json['liveVirusConflicts'] != null) {
      liveVirusConflicts = <LiveVirusConflict>[];
      json['liveVirusConflicts'].forEach((v) {
        liveVirusConflicts.add(LiveVirusConflict.fromJson(v));
      });
    }
    if (json['seriesVaccineGroups'] != null) {
      seriesVaccineGroups = <String, SeriesVaccineGroup>{};
      json['seriesVaccineGroups'].forEach((k, v) {
        seriesVaccineGroups[k] = SeriesVaccineGroup.fromJson(v);
      });
    }
    if (json['cvxToAntigenMap'] != null) {
      cvxToAntigenMap = <String, CvxMap>{};
      json['cvxToAntigenMap']
          .forEach((k, v) => cvxToAntigenMap[k] = CvxMap.fromJson(v));
    }
    if (json['observations'] != null) {
      observations = <String, Observation>{};
      json['observations']
          .forEach((k, v) => observations[k] = Observation.fromJson(v));
    }
  }

  bool isAgInCvx(String cvx, String ag) => cvxToAntigenMap[cvx].isAgInCvx(ag);
}
