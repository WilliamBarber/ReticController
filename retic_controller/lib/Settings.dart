import 'package:flutter/material.dart';
import 'StationStatusPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const Scaffold(
                        body: StationStatusPage(),
                      );
                    }),
                  );
                },
                child: Text('View all station statuses'),
            ),
          ],
        ),
      ),
    );
  }
}