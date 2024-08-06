import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'Homepage.dart';
import 'StationStatusPage.dart';
import 'dart:async';

class HomePageFramework extends StatefulWidget {
  const HomePageFramework({super.key});

  @override
  State<HomePageFramework> createState() => _HomePageFrameworkState();
}

class _HomePageFrameworkState extends State<HomePageFramework> {
  @override
  void initState() {
    super.initState();
    var appState = Provider.of<AppState>(context, listen: false);
    Timer.periodic(const Duration(seconds: 30), (Timer timer) => appState.updateDataFromServer());
    appState.updateDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var selectedIndex = appState.selectedIndex;
    var pages = const [HomePage(), StationStatusPage()];
    Widget page = pages[selectedIndex];

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
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
                icon: Icon(Icons.apps_rounded),
                label: 'Status',
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