import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:table_calendar/table_calendar.dart';

class SudokuCalendarScreen extends StatelessWidget {
  final DateTime dateTime;

  const SudokuCalendarScreen(this.dateTime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: Text(dateTime.toDateString()),
      ),
      body: TableCalendar(
        focusedDay: dateTime,
        firstDay: DateTime.utc(2012, 6, 6),
        lastDay: DateTime.now(),
        onDaySelected: (selectedDate, _) => context.pop(selectedDate),
      ),
    );
  }
}
