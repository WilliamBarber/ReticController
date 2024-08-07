import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'TimeDropDown.dart';
import 'StationDropDown.dart';

class TempStatusPage extends StatelessWidget {
  const TempStatusPage({super.key, required this.initialStation});

  final int initialStation;

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
                  appState.pushTemporaryScheduleFromQueue();
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
              leading: const Icon(Icons.timelapse_rounded),
              title: Text(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.3),
                  'Duration'),
              trailing: const TimeDropDown(initialValue: 1),
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
              trailing: StationDropDown(initialStation: initialStation),
            ),
          ],
        ),
      ),
    );
  }
}
