class ServerSimulator {
  int _activeStation = 0;
  List<Schedule> _schedules = [
    Schedule.empty(),
    Schedule([Day.monday, Day.tuesday, Day.wednesday, Day.thursday, Day.friday], 5, 0),
    Schedule([Day.monday, Day.wednesday, Day.friday], 6, 30),
    Schedule([Day.tuesday, Day.thursday, Day.saturday], 5, 30),
  ];

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

  void activateStation(int station) {
    _activeStation = station;
  }

  /*
  0: no schedule
  1: schedule 1
  2: schedule 2
  3: schedule 3
   */
  void activateSchedule(int schedule) {
    for (int i = 0; i < _schedules.length; i++) {
      _schedules[i].makeInactive();
    }
    _schedules[schedule].makeActive();
  }

  int getActiveScheduleIndex() {
    for (int i = 0; i < _schedules.length; i++) {
      if (_schedules[i].isActive()) {
        return i;
      }
    }
    return 0;
  }

  Schedule getScheduleNumber(int index) {
    return _schedules[index];
  }

}

enum Day {monday, tuesday, wednesday, thursday, friday, saturday, sunday}

class Schedule {
  int _timeHour = 0;
  int _timeMinute = 0;
  bool _active = false;
  List<Day> _days = [];

  Schedule(this._days, this._timeHour, this._timeMinute);
  Schedule.empty();

  void makeActive() {
    _active = true;
  }

  void makeInactive() {
    _active = false;
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