import 'package:flutter/material.dart';
import 'ServerSimulator.dart';

class AppState extends ChangeNotifier {
  int selectedIndex = 0;

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

  void activateSchedule(int schedule) {
    server.activateSchedule(schedule);
    activeSchedule = server.getActiveScheduleIndex();
    notifyListeners();
  }

  Column _createScheduleColumn(int scheduleNumber) {
    String dayString = server.getScheduleNumber(scheduleNumber).getDayString();
    String timeString = server.getScheduleNumber(scheduleNumber).getTimeString();
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
