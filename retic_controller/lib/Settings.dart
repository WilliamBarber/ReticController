import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: appState.getItemCount(),
                      itemBuilder: (context, innerIndex) {
                        return GestureDetector(
                          onTap: () {
                            const snackBar =
                            SnackBar(content: Text('Show Details'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(1),
                                leading: const Text('Hello!'),
                                title: const Text(
                                    'Bello!'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      'Recent Music File:',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 2.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        const snackBar = SnackBar(content: Text('Show Details'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Card(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  Text('Recent music file here'),
                                ]),
                              ))),
                    ),
                    Text(
                      'Recent Training Timer:',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 2.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        const snackBar = SnackBar(content: Text('Show Details'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Card(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  Text('Recent timer here'),
                                ]),
                              ))),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}