import 'package:flutter/material.dart';
import 'Server.dart';

class AppState extends ChangeNotifier {
  int selectedIndex = 0;

  Server server = Server();
  int activeStation = 0;
  bool reticActive = false;
  int queuedStation = 0;
  int queuedDuration = 1;

  Future<void> updateDataFromServer() async {
    await server.updateDataFromServer();
    activeStation = server.getActiveStation();
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
    bool active = server.getSchedule(scheduleIndex).isActive();
    List<Day> newDays = [];
    for (int i = 0; i < 7; i++) {
      if (queuedDayStatuses[i]) {
        newDays.add(Day.values[i]);
      }
    }
    server.replaceSchedule(scheduleIndex, Schedule(newDays, hour, minute, queuedDuration, active));
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

  bool isReticActive() {
    return activeStation != 0;
  }

  void pushTemporaryScheduleFromQueue() async {
    List<int> stations = [];
    if (queuedStation == 7) {
      for (int i = 1; i < 7; i++) {
        stations.add(i);
      }
    }
    else {
      stations.add(queuedStation);
    }
    DateTime dateTime = DateTime.now().add(const Duration(minutes: 1));
    TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
    await server.pushTemporarySchedule(stations, time.hour, time.minute, queuedDuration);
    updateDataFromServer();
  }

  void cancelTemporarySchedule() async {
    await server.cancelTemporarySchedule();
    updateDataFromServer();
  }
}
