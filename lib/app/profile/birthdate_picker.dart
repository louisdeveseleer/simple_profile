import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class BirthdatePicker extends StatefulWidget {
  const BirthdatePicker(
      {Key key, this.enabled, this.initialValue, this.onChanged})
      : super(key: key);
  final bool enabled;
  final Function(DateTime) onChanged;
  final DateTime initialValue;

  @override
  _BirthdatePickerState createState() => _BirthdatePickerState();
}

class _BirthdatePickerState extends State<BirthdatePicker> {
  DateTime selectedDate;

  void _onPressed(BuildContext context) async {
    if (Platform.isAndroid) {
      showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        helpText: 'Select your birth date',
      ).then((value) => _updateValue(value));
    } else if (Platform.isIOS) {
      DateTime datePicked;
      await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext builder) {
            return CupertinoPopupSurface(
              child: Container(
                height: 300,
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate ?? DateTime.now(),
                  maximumDate: DateTime.now(),
                  maximumYear: DateTime.now().year,
                  mode: CupertinoDatePickerMode.date,
                  minimumYear: 1900,
                  onDateTimeChanged: (DateTime value) => datePicked = value,
                ),
              ),
            );
          });
      _updateValue(datePicked);
    }
  }

  void _updateValue(DateTime newValue) {
    widget.onChanged(newValue);
    setState(() {
      selectedDate = newValue;
    });
  }

  @override
  void initState() {
    selectedDate = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enabled
        ? OutlinedButton(
            child: dateText(emptyLabel: 'Click here'),
            onPressed: () => _onPressed(context),
          )
        : dateText(emptyLabel: '-');
  }

  Widget dateText({String emptyLabel}) {
    return Text(
      selectedDate == null
          ? (emptyLabel ?? '')
          : DateFormat.yMMMd().format(selectedDate),
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
