import 'package:flutter/material.dart';
import 'DateFormatDropDown.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateFormatDropDown(),
            Text('TODO: View all station statuses'),
          ],
        ),
      ),
    );
  }
}