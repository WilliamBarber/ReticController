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
                  (appState.activeStation == 0) ? 'All Stations are Off' : 'Station ${appState.activeStation} is On',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 2.0),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    if (appState.activeStation == 0) {
                      appState.queuedDuration = 1;
                      appState.queuedStation = 'All';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Scaffold(
                            body: TempStatusPage(),
                          );
                        }),
                      );
                    } else {
                      appState.queuedStation = '0';
                      appState.queuedDuration = 1;
                      appState.activateStation();
                      appState.updateDuration();
                    }
                  },
                  child: (appState.activeStation == 0)
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
                            contentPadding: const EdgeInsets.all(1),
                            leading: Radio(
                              toggleable: true,
                              groupValue: appState.currentSchedule,
                              value: getScheduleForInt(index),
                              onChanged: (Schedule? value) {
                                if (value == null) {
                                  appState.setCurrentSchedule(Schedule.none);
                                } else {
                                  appState.setCurrentSchedule(value);
                                }
                              },
                            ),
                            title: Text('Schedule ${index + 1}'),
                            subtitle: appState.getScheduleText(index),
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
