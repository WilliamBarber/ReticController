import 'package:flutter/material.dart';

import 'AppState.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: OutlinedButton(
          onPressed: () async {
            appState.updateDataFromServer();
          },
          child: const Icon(Icons.refresh_rounded)),
    );
  }
}