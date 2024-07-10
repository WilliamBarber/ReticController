import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'DateTimeConverter.dart';
import 'package:retic_controller/TimeDropDown.dart';

class ScheduleEditPage extends StatefulWidget {
  const ScheduleEditPage({super.key, required this.scheduleIndex});

  final int scheduleIndex; //1 = schedule1, 2 = schedule2, etc.

  @override
  State<ScheduleEditPage> createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends State<ScheduleEditPage> {
  final DateTime day = DateTime.now();

  TimeOfDay time =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1)));
  late DateTime selectedDateTime = DateTimeConverter.getNextHalfHour(DateTime.parse(
      '${day.year}-${DateTimeConverter.getMonthString(day)}-${DateTimeConverter.getDayString(day)} ${DateTimeConverter.getHourStringTimeOfDay(time)}:${DateTimeConverter.getMinuteStringTimeOfDay(time)}'));

  List<bool> queuedDayStatuses = [];


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    int scheduleIndex = widget.scheduleIndex;
    for (int i = 0; i < 7; i++) {
      queuedDayStatuses.add(appState.isDayActiveInSchedule(scheduleIndex, i));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Schedule $scheduleIndex'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FilledButton(
                onPressed: () async {
                  //TODO: push to AppState/server
                  for (int i = 0; i < 7; i++) {
                    appState.setDayStatusInSchedule(scheduleIndex, i, queuedDayStatuses[i]);
                  }
                  appState.setScheduleDurationFromQueue(scheduleIndex);
                  Navigator.pop(context);
                },
                child: const Text('Save')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0),
              leading: const Icon(Icons.access_time_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Start time'),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  helpText: '',
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                );
                if (picked != null) {
                  setState(() {
                    selectedDateTime = DateTime.parse(
                        '${selectedDateTime.year}-${DateTimeConverter.getMonthString(selectedDateTime)}-${DateTimeConverter.getDayString(selectedDateTime)} ${DateTimeConverter.getHourStringTimeOfDay(picked)}:${DateTimeConverter.getMinuteStringTimeOfDay(picked)}');
                  });
                }
              },
              trailing: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  ' ${DateTimeConverter.getHourStringDateTime(selectedDateTime)}:${DateTimeConverter.getMinuteStringDateTime(selectedDateTime)}'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0),
              leading: const Icon(Icons.timelapse_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Duration '),
              trailing: TimeDropDown(initialValue: appState.getScheduleDuration(scheduleIndex)),
            ),
            const Divider(
                height: 30
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, dayIndex) {
                return SwitchListTile(
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    secondary: const Icon(Icons.calendar_month_rounded),
                    title: Text(
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.3),
                        appState.getDayForIndex(dayIndex)),
                    value: queuedDayStatuses[dayIndex],
                    onChanged: (bool value) {
                      setState(() {
                        queuedDayStatuses[dayIndex] = value;
                      });
                    });
              }
            ),
          ],
        ),
      ),
    );

  }
}
