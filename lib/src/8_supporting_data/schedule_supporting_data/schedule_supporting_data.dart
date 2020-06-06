import 'export_schedule_supporting_data.dart';

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
}
