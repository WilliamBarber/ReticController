import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'RefreshButton.dart';
import 'IndividualStatusPage.dart';

class StationStatusPage extends StatelessWidget {
  const StationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Status'),
        actions: [
          RefreshButton(appState: appState),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) {
                  //     return Scaffold(
                  //       body: IndividualStatusPage(stationNumber: index + 1),
                  //     );
                  //   }),
                  // );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(1),
                      title: Text('Station ${index + 1}: ${appState.isStationActive(index + 1)
                          ? 'Active'
                          : 'Inactive'}' ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
