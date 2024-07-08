import 'package:flutter/material.dart';

enum DateFormat {
  dayMonthYear('Day/Month/Year'),
  monthDayYear('Month/Day/Year'),
  yearMonthDay('Year/Month/Day');

  const DateFormat(this.label);

  final String label;
}


class AppState extends ChangeNotifier {
    var dateFormat = DateFormat.dayMonthYear;

  DateFormat getDateFormat() {
    return dateFormat;
  }

  void setDateFormat(DateFormat dateFormat) {
    this.dateFormat = dateFormat;
    notifyListeners();
  }

  bool getReticStatus() {
    return false;
  }

  int getItemCount() {
    return 3;
  }
}
