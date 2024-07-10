import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'package:retic_controller/TimeDropDown.dart';
import 'DateTimeConverter.dart';

class ScheduleEditPage extends StatefulWidget {
  const ScheduleEditPage({super.key, required this.scheduleIndex});

  final int scheduleIndex; //1 = schedule1, 2 = schedule2, etc.

  @override
  State<ScheduleEditPage> createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends State<ScheduleEditPage> {
  List<bool> queuedDayStatuses = [];
  late int hour;
  late int minute;
  late TimeOfDay queuedStartTime = TimeOfDay(hour: hour, minute: minute);


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    int scheduleIndex = widget.scheduleIndex;
    hour = appState.getScheduleHour(scheduleIndex);
    minute = appState.getScheduleMinute(scheduleIndex);
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
                  appState.setScheduleTime(scheduleIndex, queuedStartTime.hour, queuedStartTime.minute);
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
                  initialTime: queuedStartTime,
                );
                if (picked != null) {
                  setState(() {
                    queuedStartTime = picked;
                  });
                }
              },
              trailing: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  ' ${queuedStartTime.hour.toString()}:${DateTimeConverter.getMinuteStringTimeOfDay(queuedStartTime)}'),
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
