import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'Homepage.dart';
import 'Settings.dart';

class HomePageFramework extends StatelessWidget {
  const HomePageFramework({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final theme = Theme.of(context);

    var selectedIndex = appState.getPage();
    var pages = [HomePage(), SettingsPage()];
    Widget page = pages[selectedIndex];

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: theme.colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
                appState.setPage(index);
              },
            ),
      );
    });
  }}