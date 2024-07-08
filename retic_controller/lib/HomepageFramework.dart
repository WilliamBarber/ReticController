import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';
import 'Homepage.dart';

class HomePageFramework extends StatelessWidget {
  const HomePageFramework({super.key});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    Widget page = HomePage();
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }}