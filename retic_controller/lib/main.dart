import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import "AppState.dart";
import "HomepageFramework.dart";

//TODO: Update DynamicColor once new version is available!!!

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue);

  static final _defaultDarkColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);


  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
            title: 'Retic Controller',
            theme: ThemeData(
              colorScheme: lightColorScheme ?? _defaultLightColorScheme,
              useMaterial3: true,
              /* uncomment for predictive back gesture
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  // Use PredictiveBackPageTransitionsBuilder to get the predictive back route transition!
                  TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
                },
              ),
                */
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
              useMaterial3: true,
            ),
            home: const HomePageFramework(),
          ),
      );
    }
    );
  }
}