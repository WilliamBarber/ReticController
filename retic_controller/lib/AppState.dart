import 'package:flutter/material.dart';
import 'ServerSimulator.dart';

enum DateFormat {
  dayMonthYear('Day/Month/Year'),
  monthDayYear('Month/Day/Year'),
  yearMonthDay('Year/Month/Day');

  const DateFormat(this.label);

  final String label;
}


class AppState extends ChangeNotifier {
  int selectedIndex = 0;
  var dateFormat = DateFormat.dayMonthYear;

  ServerSimulator server = ServerSimulator();
  int duration = 1; //TODO: pull from server
  int activeSchedule = 1;
  int activeStation = 0;
  bool reticActive = false;
  int queuedStation = 0;
  int queuedDuration = 1;

  void setPage(int page) {
    selectedIndex = page;
    notifyListeners();
  }

  bool isDayActiveInSchedule(int scheduleIndex, int dayIndex) {
    return server.getSchedule(scheduleIndex).getDays().contains(Day.values[dayIndex]);
  }

  void setDayStatusInSchedule(int scheduleIndex, int dayIndex, bool active) {
    Schedule oldSchedule = server.getSchedule(scheduleIndex);
    List<Day> newDays = oldSchedule.getDays();
    if (active) {
      newDays.add(Day.values[dayIndex]);
    }
    else {
      newDays.remove(Day.values[dayIndex]);
    }
    server.replaceSchedule(scheduleIndex, Schedule(newDays, oldSchedule.getHour(), oldSchedule.getMinute(), oldSchedule.getDuration()));
    notifyListeners();
  }

  String getDayForIndex(int index) {
    String dayString = Day.values[index].toString();
    dayString = dayString.substring(dayString.indexOf('.') + 1);
    return dayString.replaceFirst(dayString[0], dayString[0].toUpperCase());
  }

  void activateSchedule(int schedule) {
    server.activateSchedule(schedule);
    activeSchedule = server.getActiveScheduleIndex();
    notifyListeners();
  }

  int getScheduleDuration(int schedule) {
    return server.getSchedule(schedule).getDuration();
  }

  void setScheduleDurationFromQueue(int schedule) {
    Schedule oldSchedule = server.getSchedule(schedule);
    server.replaceSchedule(schedule, Schedule(oldSchedule.getDays(), oldSchedule.getHour(), oldSchedule.getMinute(), queuedDuration));
  }

  Column _createScheduleColumn(int scheduleNumber) {
    String dayString = server.getSchedule(scheduleNumber).getDayString();
    String timeString = server.getSchedule(scheduleNumber).getTimeString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(dayString),
        Text(timeString),
      ],
    );
  }

  Align getScheduleText(int scheduleNumber) {
      return Align(
        alignment: Alignment.topLeft,
        child: _createScheduleColumn(scheduleNumber),
      );
  }

  bool isStationActive(int station) {
    return station == activeStation;
  }

  void activateStationFromQueue() {
    server.activateStation(queuedStation);
    activeStation = server.getActiveStation();
    if (activeStation == 7) {
      runAll();
      return;
    }
    else if (activeStation == 0) {
      reticActive = false;
    }
    else {
      reticActive = true;
    }

    notifyListeners();
  }

  void updateDurationFromQueue() {
    duration = queuedDuration; //TODO: push to server
    notifyListeners();
  }

  void runAll() {
    queuedStation = 1; //TODO: this needs to run all stations in order. Will need to push to server.
    activateStationFromQueue();
  }
}
