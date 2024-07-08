import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'DateTimeConverter.dart';

class TempStatusPage extends StatefulWidget {
  final DateTime day = DateTime.now();

  @override
  State<TempStatusPage> createState() => _TempStatusPageState();
}

class _TempStatusPageState extends State<TempStatusPage> {
  TimeOfDay time =
  TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1)));
  late DateTime selectedDateTime = DateTimeConverter.getNextHalfHour(DateTime.parse(
      '${widget.day.year}-${DateTimeConverter.getMonthString(widget.day)}-${DateTimeConverter.getDayString(widget.day)} ${DateTimeConverter.getHourStringTimeOfDay(time)}:${DateTimeConverter.getMinuteStringTimeOfDay(time)}'));
  String activityTitle = 'No title';
  String activityDescription = 'No description';
  bool repeatActivity = false;
  bool hasMusicFile = false;

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Temporary Status'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: FilledButton(
                onPressed: () async {
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
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              leading: Icon(Icons.calendar_month_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Activity date'),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  helpText: '',
                  context: context,
                  initialDate: selectedDateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 10),
                );
                if (picked != null) {
                  setState(() {
                    selectedDateTime = DateTime.parse(
                        '${picked.year}-${DateTimeConverter.getMonthString(picked)}-${DateTimeConverter.getDayString(picked)} 09:00:00');
                  });
                }
              },
              trailing: formattedSelectionDate(appState.getDateFormat()),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              leading: Icon(Icons.access_time_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Activity reminder'),
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
            SwitchListTile(
                contentPadding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                secondary: Icon(Icons.event_repeat_rounded),
                title: Text(
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 1.3),
                    'Repeat activity weekly'),
                value: repeatActivity,
                onChanged: (bool value) {
                  setState(() {
                    repeatActivity = value;
                  });
                }),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              leading: Icon(Icons.attach_file_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Music file'),
              onTap: () async {
                print(Text('NOT IMPLEMENTED'));
              },
              trailing: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'None attached'),
            ),
            // showModalBottomSheet<void>(
            //             context: context,
            //             builder: (BuildContext context) {
            //               return SizedBox(
            //                 height: 78,
            //                 child: Center(
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.center,
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: <Widget>[
            //                       ElevatedButton(
            //                         onPressed: () {
            //                           _getFromGallery();
            //                         },
            //                         child: Text('Pick From File'),
            //                       ),
            //                       Padding(
            //                         padding: EdgeInsets.all(5),
            //                       ),
            //                       ElevatedButton(
            //                         onPressed: () {
            //                           _getFromCamera();
            //                         },
            //                         child: Text('Take a Photo'),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
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