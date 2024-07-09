import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';

class StationStatusPage extends StatelessWidget {
  const StationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Statuses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(1),
                    leading: Text('Station ${index + 1}'),
                    title: Text(appState.isStationActive(index + 1)
                        ? 'Active'
                        : 'Inactive'),
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
