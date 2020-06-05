class SeriesVaccineGroup {
  List<String> antigens;
  bool administerFullseriesVaccineGroup;

  SeriesVaccineGroup({
    this.antigens,
    this.administerFullseriesVaccineGroup,
  });

  SeriesVaccineGroup.fromJson(Map<String, dynamic> json) {
    if (json['antigens'] != null) antigens = json['antigens'].cast<String>();
    administerFullseriesVaccineGroup =
        json['administerFullseriesVaccineGroup'] as bool;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['antigens'] = antigens;
    data['administerFullSeriesVaccineGroup'] = administerFullseriesVaccineGroup;
    return data;
  }
}
