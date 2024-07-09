import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'DateTimeConverter.dart';
import 'TimeDropDown.dart';
import 'StationDropDown.dart';

class TempStatusPage extends StatefulWidget {
  TempStatusPage({super.key});

  final DateTime day = DateTime.now();


  @override
  State<TempStatusPage> createState() => _TempStatusPageState();
}

class _TempStatusPageState extends State<TempStatusPage> {
  TimeOfDay time =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1)));
  late DateTime selectedDateTime = DateTimeConverter.getNextHalfHour(DateTime.parse(
      '${widget.day.year}-${DateTimeConverter.getMonthString(widget.day)}-${DateTimeConverter.getDayString(widget.day)} ${DateTimeConverter.getHourStringTimeOfDay(time)}:${DateTimeConverter.getMinuteStringTimeOfDay(time)}'));

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Temporary Status'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FilledButton(
                onPressed: () async {
                    appState.activateStation();
                    appState.updateDuration();
                    Navigator.pop(context);
                },
                child: const Text('Start')),
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
                  'Start Time'),
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
                  '${DateTimeConverter.getHourStringDateTime(selectedDateTime)}:${DateTimeConverter.getMinuteStringDateTime(selectedDateTime)}'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0),
              leading: const Icon(Icons.access_time_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Duration'),
              trailing: const TimeDropDown(),
            ),
            const Divider(
              height: 30
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0),
              leading: const Icon(Icons.water_drop_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Station'),
              trailing: const StationDropDown(),
            ),
          ],
        ),
      ),
    );
  }

  Text formattedSelectionDate(DateFormat dateFormat) {
    if (dateFormat == DateFormat.dayMonthYear) {
      return Text(
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.3),
          ' ${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}');
    } else if (dateFormat == DateFormat.monthDayYear) {
      return Text(
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.3),
          ' ${selectedDateTime.month}/${selectedDateTime.day}/${selectedDateTime.year}');
    } else {
      return Text(
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.3),
          ' ${selectedDateTime.year}/${selectedDateTime.month}/${selectedDateTime.day}');
    }
  }
}
