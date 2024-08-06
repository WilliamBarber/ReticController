import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

enum Day {monday, tuesday, wednesday, thursday, friday, saturday, sunday, none}

Day convertToDayEnum(String day) {
  switch (day) {
    case 'MON':
      return Day.monday;
    case 'TUE':
      return Day.tuesday;
    case 'WED':
      return Day.wednesday;
    case 'THU':
      return Day.thursday;
    case 'FRI':
      return Day.friday;
    case 'SAT':
      return Day.saturday;
    case 'SUN':
      return Day.sunday;
    default:
      return Day.none;
  }
}

List<Day> convertToDayEnumList(List<String> days) {
  List<Day> enumDayList = [];
  for (String day in days) {
    enumDayList.add(convertToDayEnum(day));
  }
  return enumDayList;
}

String convertToDayString(Day day) {
  switch (day) {
    case Day.monday:
      return 'MON';
    case Day.tuesday:
      return 'TUE';
    case Day.wednesday:
      return 'WED';
    case Day.thursday:
      return 'THU';
    case Day.friday:
      return 'FRI';
    case Day.saturday:
      return 'SAT';
    case Day.sunday:
      return 'SUN';
    default:
      return '';
  }
}

List<String> convertToDayStringList(List<Day> days) {
  List<String> stringDayList = [];
  for (Day day in days) {
    stringDayList.add(convertToDayString(day));
  }
  return stringDayList;
}


class Server {
  int _activeStation = 0;
  List<Schedule> _schedules = [
    Schedule.empty(),
    Schedule.empty(),
    Schedule.empty(),
    Schedule.empty(),
  ];

  Future<List<Schedule>> _fetchSchedules() async {
    var response = jsonDecode((await http.get(Uri.parse('http://192.168.0.241/cgi-bin/listSchedules.py'))).body) as Map<String, dynamic>;
    List<Schedule> schedules = [Schedule.empty()];
    for (var job in response['jobs']) {
      List<Day> days = convertToDayEnumList(List<String>.from(job['job_spec']['days_of_week']));
      schedules.add(Schedule(days, job['job_spec']['start_hour'], job['job_spec']['start_minute'], job['job_spec']['duration'], job['job_spec']['enabled']));
    }
    return schedules;
  }

  Future<int> _fetchActiveStation() async {
    var response = jsonDecode((await http.get(Uri.parse('http://192.168.0.241/cgi-bin/getActiveStation.py'))).body) as Map<String, dynamic>;
    return response['active_station'];
  }

  Future<void> _pushSchedules(List<Schedule> schedules) async {
    for (int i = 1; i < schedules.length; i++) {
      Schedule schedule = schedules[i];
      List<String> days = convertToDayStringList(schedule.getDays());
      int startHour = schedule.getHour();
      int startMinute = schedule.getMinute();
      int duration = schedule.getDuration();
      bool enabled = schedule.isActive();
      http.put(
        Uri.parse('http://192.168.0.241/cgi-bin/updateSchedule.py/$i'),
        body: jsonEncode(<String, dynamic> {
          'days_of_week' : days,
          'start_hour' : startHour,
          'start_minute' : startMinute,
          'duration' : duration,
          'enabled' : enabled,
        }),
      );
    }
  }

  Future<void> pushTemporarySchedule(List<int> stations, int startHour, int startMinute, int duration) async {
    http.put(
        Uri.parse('http://192.168.0.241/cgi-bin/temporarySchedule.py'),
      body: jsonEncode(<String, dynamic> {
        'stations' : stations,
        'start_hour' : startHour,
        'start_minute' : startMinute,
        'duration' : duration,
      }),
    );
  }

  Future<void> cancelTemporarySchedule() async {
    http.put(Uri.parse('http://192.168.0.241/cgi-bin/disableRetic.py'));
  }

  Future<void> updateDataFromServer() async {
    _schedules = await _fetchSchedules();
    _activeStation = await _fetchActiveStation();
  }

  /*
  0: no active station
  1: station 1 is active
  2: station 2 is active
  ...
  6: station 6 is active
   */
  int getActiveStation() {
    return _activeStation;
  }

  /*
  0: no schedule
  1: schedule 1
  2: schedule 2
  3: schedule 3
   */
  int getActiveScheduleIndex() {
    for (int i = 0; i < _schedules.length; i++) {
      if (_schedules[i].isActive()) {
        return i;
      }
    }
    return 0;
  }

  void activateSchedule(int schedule) {
    List<Schedule> schedules = _schedules;
    for (int i = 0; i < schedules.length; i++) {
      schedules[i] = schedules[i].makeInactive();
    }
    schedules[schedule] = schedules[schedule].makeActive();
    _pushSchedules(schedules);
  }

  Schedule getSchedule(int index) {
    return _schedules[index];
  }

  void replaceSchedule(int scheduleIndex, Schedule newSchedule) {
    List<Schedule> schedules = _schedules;
    schedules[scheduleIndex] = newSchedule;
    _pushSchedules(schedules);
  }

}

class Schedule {
  int _timeHour = 0;
  int _timeMinute = 0;
  int _cycleDuration = 0;
  bool _active = false;
  List<Day> _days = [];

  Schedule(this._days, this._timeHour, this._timeMinute, this._cycleDuration, this._active);
  Schedule.empty();

  Schedule makeActive() {
    return Schedule(_days, _timeHour, _timeMinute, _cycleDuration, true);
  }

  Schedule makeInactive() {
    return Schedule(_days, _timeHour, _timeMinute, _cycleDuration, false);
  }

  bool isEmpty() {
    return _days.isEmpty;
  }

  bool isActive() {
    return _active;
  }

  List<Day> getDays() {
    return _days;
  }

  int getHour() {
    return _timeHour;
  }

  int getMinute() {
    return _timeMinute;
  }

  int getDuration() {
    return _cycleDuration;
  }

  String getTimeString() {
    String hour = _timeHour >= 10 ? _timeHour.toString() : '0$_timeHour';
    String minute = _timeMinute >= 10 ? _timeMinute.toString() : '0$_timeMinute';
    return '$hour:$minute';
  }

  String getDayString() {
    String string = '';
    if (_days.contains(Day.monday)) {
      string += "M";
    }
    if (_days.contains(Day.tuesday)) {
      string += string.isNotEmpty ? ", T" : "T";
    }
    if (_days.contains(Day.wednesday)) {
      string += string.isNotEmpty ? ", W" : "W";
    }
    if (_days.contains(Day.thursday)) {
      string += string.isNotEmpty ? ", Th" : "Th";
    }
    if (_days.contains(Day.friday)) {
      string += string.isNotEmpty ? ", F" : "F";
    }
    if (_days.contains(Day.saturday)) {
      string += string.isNotEmpty ? ", Sa" : "Sa";
    }
    if (_days.contains(Day.sunday)) {
      string += string.isNotEmpty ? ", Su" : "Su";
    }

    return string;
  }

}