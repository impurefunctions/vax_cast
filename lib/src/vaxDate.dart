import 'package:intl/intl.dart';
import 'package:date_utils/date_utils.dart';

class VaxDate extends DateTime {
  VaxDate(int year, int month, int day) : super(year, month, day);

  VaxDate.fromString(String date)
      : super(DateTime.parse(date).year, DateTime.parse(date).month,
            DateTime.parse(date).day);

  VaxDate.dt(DateTime dateTime)
      : super(dateTime.year, dateTime.month, dateTime.day);

  VaxDate.now() : super.now();

  VaxDate.min() : super(1900, 1, 1);

  VaxDate.max() : super(2999, 12, 31);

  VaxDate.mmddyyyy(String date)
      : super(
          DateFormat('MM/dd/yyyy').parse(date).year,
          DateFormat('MM/dd/yyyy').parse(date).month,
          DateFormat('MM/dd/yyyy').parse(date).day,
        );

  VaxDate fromNullableString(String date) =>
      date == null ? this : VaxDate.mmddyyyy(date);

  VaxDate minIfNull(String dateChange) =>
      dateChange == null ? VaxDate(1900, 1, 1) : change(dateChange);

  VaxDate maxIfNull(String dateChange) =>
      dateChange == null ? VaxDate(2999, 12, 31) : change(dateChange);

  bool operator <(VaxDate vaxDate) {
    return (DateTime(year, month, day)
        .isBefore(DateTime(vaxDate.year, vaxDate.month, vaxDate.day)));
  }

  bool operator >(VaxDate vaxDate) {
    return (DateTime(year, month, day)
        .isAfter(DateTime(vaxDate.year, vaxDate.month, vaxDate.day)));
  }

  bool operator <=(VaxDate vaxDate) {
    return (DateTime(year, month, day)
            .isBefore(DateTime(vaxDate.year, vaxDate.month, vaxDate.day)) ||
        DateTime(year, month, day).isAtSameMomentAs(
            DateTime(vaxDate.year, vaxDate.month, vaxDate.day)));
  }

  bool operator >=(VaxDate vaxDate) {
    return (DateTime(year, month, day)
            .isAfter(DateTime(vaxDate.year, vaxDate.month, vaxDate.day)) ||
        DateTime(year, month, day).isAtSameMomentAs(
            DateTime(vaxDate.year, vaxDate.month, vaxDate.day)));
  }

  bool isEqualTo(VaxDate vaxDate) {
    return (DateTime(year, month, day)
        .isAtSameMomentAs(DateTime(vaxDate.year, vaxDate.month, vaxDate.day)));
  }

  VaxDate change(String howMuch) =>
      (howMuch == null ? this : _parseDateString(howMuch));

  VaxDate changeIfNotNull(String howMuch) =>
      howMuch == null ? null : change(howMuch);

  VaxDate _parseDateString(String change) {
    var years = 0, months = 0, weeks = 0, days = 0, posNeg = 1;
    var time = change.split(' ');
    for (var i = 0; i < time.length; i++) {
      if (i > 1) {
        if (time[i - 2] == '-') {
          posNeg = -1;
        } else {
          posNeg = 1;
        }
      }
      if (time[i].contains('year')) {
        years += int.tryParse(time[i - 1]) * posNeg;
      }
      if (time[i].contains('month')) {
        months += int.tryParse(time[i - 1]) * posNeg;
      }
      if (time[i].contains('week')) {
        weeks += int.tryParse(time[i - 1]) * posNeg;
      }
      if (time[i].contains('day')) {
        days += int.tryParse(time[i - 1]) * posNeg;
      }
    }
    return _calculateTime(years, months, 7 * weeks + days);
  }

  VaxDate _calculateTime(int years, int months, int days) {
    var newDate = DateTime(year + years, month + months, 1);
    if (Utils.lastDayOfMonth(newDate).day < day) {
      newDate = DateTime(newDate.year, newDate.month + 1, 1);
    } else {
      newDate = DateTime(newDate.year, newDate.month, day);
    }
    return VaxDate(newDate.year, newDate.month, newDate.day + days);
  }
}

VaxDate LatestOf(List<VaxDate> dates) {
  var latest;
  for (final date in dates) {
    latest = date == null
        ? latest
        : latest == null ? date : latest > date ? latest : date;
  }
  return latest;
}

VaxDate EarliestOf(List<VaxDate> dates) {
  var earliest;
  for (final date in dates) {
    if (date != null) {
      if (earliest == null) {
        earliest = date;
      } else {
        earliest = earliest < date ? earliest : date;
      }
    }
  }
  return earliest;
}
