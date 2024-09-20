import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_day_planner/task_view/bloc/task_view_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectDate extends StatefulWidget {
  SelectDate(this.dateTime, this._onChangeDateTime, {super.key});

  final DateTime dateTime;

  final void Function(DateTime newDateTime) _onChangeDateTime;

  @override
  State<SelectDate> createState() => _SelectDateState(dateTime);
}

class _SelectDateState extends State<SelectDate> {
  _SelectDateState(this._datetime);

  DateTime _datetime;

  void _setDate(DateTime newDateTime) {
    widget._onChangeDateTime(newDateTime);
    setState(() {
      _datetime = newDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () async {
              _setDate(_datetime.subtract(Duration(days: 1)));
            },
            child: Text('<')),
        TextButton(
            onPressed: () async {
              final datetime = await showDatePicker(
                  initialDate: _datetime,
                  context: context,
                  firstDate: DateFormat('yyyy-MM-dd').parse('2020-01-01'),
                  lastDate: DateFormat('yyyy-MM-dd').parse('2026-01-01'));
              if (datetime != null) _setDate(datetime);
            },
            child: Text('${DateFormat('dd-MM-yyyy').format(_datetime)}')),
        TextButton(
            onPressed: () {
              _setDate(_datetime.add(Duration(days: 1)));
            },
            child: Text('>'))
      ],
    );
  }
}
