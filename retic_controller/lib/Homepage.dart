import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'TempStatusPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
                child: Column(
              children: [
                Text(
                  (!appState.reticActive) ? 'All Stations are Off' : 'Station ${appState.activeStation} is On',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 2.0),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    if (!appState.reticActive) {
                      appState.queuedStation = 7;
                      appState.queuedDuration = 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const Scaffold(
                            body: TempStatusPage(),
                          );
                        }),
                      );
                    } else {
                      appState.queuedStation = 0;
                      appState.queuedDuration = 1;
                      appState.activateStationFromQueue();
                      appState.updateDurationFromQueue();
                    }
                  },
                  child: (!appState.reticActive)
                      ? const Text('Turn on Temporarily')
                      : const Text('Turn off'),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        const snackBar =
                            SnackBar(content: Text('Show Details'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            isThreeLine: true,
                            contentPadding: const EdgeInsets.all(1),
                            leading: Radio(
                              toggleable: true,
                              groupValue: appState.activeSchedule - 1,
                              value: index,
                              onChanged: (value) {
                                if (value == null) {
                                  appState.activateSchedule(0);
                                } else {
                                  appState.activateSchedule(value + 1);
                                }
                              },
                            ),
                            title: Text('Schedule ${index + 1}'),
                            subtitle: appState.getScheduleText(index + 1),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
