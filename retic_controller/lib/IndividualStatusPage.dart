import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'RefreshButton.dart';
import 'TempStatusPage.dart';

class IndividualStatusPage extends StatelessWidget {
  IndividualStatusPage({super.key, required this.stationNumber});

  final int stationNumber;
  final List<String> stationDetails = [
    "No station",
    "Garage-side flowerbeds",
    "Front lawn",
    "Front flowerbeds",
    "House-side back lawn",
    "Fence-side back lawn",
    "Back flowerbeds",
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Station $stationNumber Details'),
        actions: [
          RefreshButton(appState: appState),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    (appState.isStationActive(stationNumber)) ? 'Station On' : 'Station Off',
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2.0),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      if (!appState.isReticActive()) {
                        appState.queuedStation = stationNumber;
                        appState.queuedDuration = 1;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              body: TempStatusPage(initialStation: stationNumber),
                            );
                          }),
                        );
                      } else {
                        appState.cancelTemporarySchedule();
                      }
                    },
                    child: (!appState.isStationActive(stationNumber))
                        ? const Text('Turn on Temporarily')
                        : const Text('Turn off'),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(1),
                        title: Text(
                          'Location: ${stationDetails[stationNumber]}',
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.5),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(1),
                        title: Text(
                          'Active in the following schedules:\n',
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.5),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
