import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppState.dart';

//TODO: Fix issue with previous selection being used instead of default value

class _DateFormatDropDownState extends State<DateFormatDropDown> {
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var dateFormat = appState.dateFormat;

    List<DropdownMenuEntry<DateFormat>> dateFormatEntries =
        <DropdownMenuEntry<DateFormat>>[];
    for (DateFormat dateFormat in DateFormat.values) {
      dateFormatEntries
          .add(DropdownMenuEntry(value: dateFormat, label: dateFormat.label));
    }

    return DropdownMenu<DateFormat>(
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      label: const Text('Date Format'),
      initialSelection: dateFormat,
      onSelected: (DateFormat? value) {
        setState(() {
          dropDownValue = value.toString();
          appState.setDateFormat(value!);
          dateFormat = value;
        });
      },
      dropdownMenuEntries: dateFormatEntries,
    );
  }
}

class DateFormatDropDown extends StatefulWidget {
  const DateFormatDropDown({super.key});

  @override
  State<DateFormatDropDown> createState() => _DateFormatDropDownState();
}
