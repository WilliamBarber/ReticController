enum Day {monday, tuesday, wednesday, thursday, friday, saturday, sunday}

List<Schedule> fakeServerSchedules = [
  Schedule.empty(),
  Schedule([Day.monday, Day.tuesday, Day.wednesday, Day.thursday, Day.friday], 5, 0, 10, true),
  Schedule([Day.monday, Day.wednesday, Day.friday], 6, 30, 15, false),
  Schedule([Day.tuesday, Day.thursday, Day.saturday], 5, 30, 15, false),
];

int fakeServerActiveStation = 0;

class Server {
  int _activeStation = 0;
  List<Schedule> _schedules = [
    Schedule.empty(),
    Schedule.empty(),
    Schedule.empty(),
    Schedule.empty(),
  ];

  Future<List<Schedule>> _fetchSchedules() async { //TODO: pull from server
    return Future.delayed(const Duration(seconds: 1), () => fakeServerSchedules);
  }

  Future<int> _fetchActiveStation() async { //TODO: pull from server
    return Future.delayed(const Duration(seconds: 1), () => fakeServerActiveStation);
  }

  Future<void> _pushSchedules(List<Schedule> schedules) async { //TODO: push to server
    fakeServerSchedules = schedules;
  }

  Future<void> _pushActiveStation(int station) async { //TODO: push to server
    fakeServerActiveStation = station;
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

  void activateStation(int station) {
    _pushActiveStation(station);
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