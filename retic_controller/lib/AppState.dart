import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var selectedIndex = 0;
  var dateFormat = DateFormat.dayMonthYear;
  var reticEnabled = false;
  var currentSchedule = Schedule.one; //TODO: pull from server
  var activeStation = 0; //TODO: pull from server
  var duration = 1; //TODO: pull from server
  var queuedStation = '0';
  var queuedDuration = 1;

  void setPage(int page) {
    selectedIndex = page;
    notifyListeners();
  }

  void setDateFormat(DateFormat dateFormat) {
    this.dateFormat = dateFormat;
    notifyListeners();
  }

  void setCurrentSchedule(Schedule schedule) {
    currentSchedule = schedule; //TODO: push to server
    notifyListeners();
  }

  Text _createScheduleText(int index) { //TODO: pull from server
    var scheduleString = '';
    if (index == 0) {
      scheduleString += 'M, ';
      scheduleString += 'T, ';
      scheduleString += 'TH, ';
      scheduleString += 'SA';
    }
    else if (index == 1) {
      scheduleString += 'M, ';
      scheduleString += 'W, ';
      scheduleString += 'SA';
    }
    else {
      scheduleString += 'T, ';
      scheduleString += 'W, ';
      scheduleString += 'TH, ';
      scheduleString += 'F, ';
      scheduleString += 'SA';
    }
    return Text(scheduleString);
  }

  Align getScheduleText(int index) {
      return Align(
        alignment: Alignment.topLeft,
        child: _createScheduleText(index),
      );
  }

  void activateStation() {
    var station = 1;
    if (queuedStation.length <= 1) {
      station = int.parse(queuedStation);
    }
    activeStation = station; //TODO: push to server (note: may need to do a single or a full cycle)
    queuedStation = '0';
    notifyListeners();
  }

  void updateDuration() {
    duration = queuedDuration; //TODO: push to server
    notifyListeners();
  }

  void runAll() {
    queuedStation = '1';
    activateStation();
  }
}

enum DateFormat {
  dayMonthYear('Day/Month/Year'),
  monthDayYear('Month/Day/Year'),
  yearMonthDay('Year/Month/Day');

  const DateFormat(this.label);
  final String label;
}

enum Schedule {none, one, two, three}

Schedule getScheduleForInt(int value) {
  if (value == 0) {
    return Schedule.one;
  } else if (value == 1) {
    return Schedule.two;
  } else {
    return Schedule.three;
  }
}
