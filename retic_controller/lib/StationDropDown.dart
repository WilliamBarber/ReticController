import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';

class _StationDropDownState extends State<StationDropDown> {
  String? dropDownValue;

  List<String> stationList = <String>[
    'All',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    int initialStation = widget.initialStation;

    return DropdownMenu<String>(
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      initialSelection: stationList[initialStation],
      onSelected: (String? value) {
        setState(() {
            dropDownValue = value!;
            appState.queuedStation = value.length > 1 ? 7 : int.parse(value); // 7 for all stations
          }
        );
      },
      dropdownMenuEntries:
      stationList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value.toString(),
        );
      }).toList(),
    );
  }
}


class StationDropDown extends StatefulWidget {
  const StationDropDown({super.key, required this.initialStation});

  final int initialStation;

  @override
  State<StationDropDown> createState() => _StationDropDownState();
}