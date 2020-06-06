part of 'a_dose.dart';

bool isInadvertentDose(SeriesDose seriesDose, String cvx) =>
    seriesDose.inadvertentVaccine == null
        ? false
        : seriesDose.inadvertentVaccine
                    .indexWhere((vaccine) => vaccine.cvx == cvx) ==
                -1
            ? false
            : true;
