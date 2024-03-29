import 'package:app_common_flutter/extension.dart';
import 'package:app_common_flutter/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:table_calendar/table_calendar.dart';

class SudokuCalendarScreen extends StatelessWidget {
  final DateTime dateTime;

  const SudokuCalendarScreen(this.dateTime, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: Text(dateTime.dateString),
      ),
      body: TableCalendar(
        focusedDay: dateTime,
        firstDay: DateTime.utc(2020, 10, 4),
        lastDay: DateTime.now(),
        onDaySelected: (selectedDate, _) => context.pop(selectedDate),
      ),
    );
  }
}
