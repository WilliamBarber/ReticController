import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AppState.dart';

class DateTimeConverter {
  static String weekdayToString(int dateInt) {
    switch (dateInt) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Invalid Date';
    }
  }

  static String getMonthString(DateTime dateTime) {
    late String tempMonth;
    dateTime.month < 10
        ? tempMonth = '0${dateTime.month}'
        : tempMonth = dateTime.month.toString();
    return tempMonth;
  }

  static String getDayString(DateTime dateTime) {
    late String tempDay;
    dateTime.day < 10
        ? tempDay = '0${dateTime.day}'
        : tempDay = dateTime.day.toString();
    return tempDay;
  }

  static String getHourStringDateTime(DateTime dateTime) {
    late String tempHour;
    dateTime.hour < 10
        ? tempHour = '0${dateTime.hour}'
        : tempHour = '${dateTime.hour}';
    return tempHour;
  }

  static String getMinuteStringDateTime(DateTime dateTime) {
    late String tempMinute;
    dateTime.minute < 10
        ? tempMinute = '0${dateTime.minute}'
        : tempMinute = '${dateTime.minute}';
    return tempMinute;
  }

  static String getHourStringTimeOfDay(TimeOfDay timeOfDay) {
    late String tempHour;
    timeOfDay.hour < 10
        ? tempHour = '0${timeOfDay.hour}'
        : tempHour = '${timeOfDay.hour}';
    return tempHour;
  }

  static String getMinuteStringTimeOfDay(TimeOfDay timeOfDay) {
    late String tempMinute;
    timeOfDay.minute < 10
        ? tempMinute = '0${timeOfDay.minute}'
        : tempMinute = '${timeOfDay.minute}';
    return tempMinute;
  }

  static String getDateStringYearMonthDay(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  static String getDateStringDayMonthYear(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String getDateStringMonthDayYear(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  static String formattedDate(DateTime dateTime, BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.getDateFormat() == DateFormat.dayMonthYear) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (appState.getDateFormat() == DateFormat.monthDayYear) {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    } else {
      return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
    }
  }

  static compareDates(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static getNextHalfHour(DateTime dateTime) {
    if (dateTime.minute < 30) {
      return dateTime.add(Duration(minutes: 30 - dateTime.minute));
    } else {
      return dateTime.add(Duration(minutes: 60 - dateTime.minute));
    }
  }
}
