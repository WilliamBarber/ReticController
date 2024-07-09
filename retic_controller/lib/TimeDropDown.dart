import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';

class _TimeDropDownState extends State<TimeDropDown> {
  String? dropDownValue;

  List<String> timesList = <String>[
    '1',
    '2',
    '5',
    '10',
    '15',
    '30',
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();


    return DropdownMenu<String>(
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      label: const Text('Minute(s)'),
      initialSelection: timesList[0],
      onSelected: (String? value) {
        setState(() {
          dropDownValue = value!;
          appState.queuedDuration = int.parse(value);
        });
      },
      dropdownMenuEntries:
      timesList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value.toString(),
        );
      }).toList(),
    );
  }
}


class TimeDropDown extends StatefulWidget {
  const TimeDropDown({super.key});

  @override
  State<TimeDropDown> createState() => _TimeDropDownState();
}