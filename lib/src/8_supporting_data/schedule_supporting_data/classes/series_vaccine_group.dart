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
}
