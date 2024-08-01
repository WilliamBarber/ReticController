import 'package:flutter/material.dart';
import 'Server.dart';

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

  Server server = Server();
  int tempDuration = 1; //TODO: pull from server
  int activeStation = 0;
  bool reticActive = false;
  int queuedStation = 0;
  int queuedDuration = 1;

  Future<void> updateDataFromServer() async {
    await server.updateDataFromServer();
    notifyListeners();
  }

  void setPage(int page) {
    selectedIndex = page;
    notifyListeners();
  }

  bool isDayActiveInSchedule(int scheduleIndex, int dayIndex) {
    return server.getSchedule(scheduleIndex).getDays().contains(Day.values[dayIndex]);
  }

  void updateScheduleFromQueue(int scheduleIndex, List<bool> queuedDayStatuses, int hour, int minute) {
    Schedule oldSchedule = server.getSchedule(scheduleIndex);
    List<Day> newDays = [];
    for (int i = 0; i < 7; i++) {
      if (queuedDayStatuses[i]) {
        newDays.add(Day.values[i]);
      }
    }
    server.replaceSchedule(scheduleIndex, Schedule(newDays, hour, minute, queuedDuration, oldSchedule.isActive()));
    notifyListeners();
  }

  String getDayForIndex(int index) {
    String dayString = Day.values[index].toString();
    dayString = dayString.substring(dayString.indexOf('.') + 1);
    return dayString.replaceFirst(dayString[0], dayString[0].toUpperCase());
  }

  int getScheduleHour(int schedule) {
    return server.getSchedule(schedule).getHour();
  }

  int getScheduleMinute(int schedule) {
    return server.getSchedule(schedule).getMinute();
  }

  void activateSchedule(int schedule) {
    server.activateSchedule(schedule);
    notifyListeners();
  }

  int getActiveScheduleIndex() {
    return server.getActiveScheduleIndex();
  }

  int getScheduleDuration(int schedule) {
    return server.getSchedule(schedule).getDuration();
  }

  Column _createScheduleColumn(int scheduleNumber) {
    String dayString = server.getSchedule(scheduleNumber).getDayString();
    String timeString = 'Start: ${server.getSchedule(scheduleNumber).getTimeString()} | Duration: ${server.getSchedule(scheduleNumber).getDuration()} minutes';
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

  /* alternate option:
    void activateStationFromQueue() async {
      server.activateStation(queuedStation);
      await updateDataFromServer();
      activeStation = server.getActiveStation();
      ...
    }
   */
  void activateStationFromQueue() {
    server.activateStation(queuedStation);
    activeStation = queuedStation;
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

  void updateTempDurationFromQueue() {
    tempDuration = queuedDuration; //TODO: push to server
    notifyListeners();
  }

  void runAll() {
    queuedStation = 1; //TODO: this needs to run all stations in order. Will need to push to server.
    activateStationFromQueue();
  }
}
