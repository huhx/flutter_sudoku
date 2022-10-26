import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final BoxBorder boxBorder;
  final List<int>? noteValue;
  final int value;
  final Color? color;
  final Color? textColor;

  const SudokuCell({
    super.key,
    required this.boxBorder,
    required this.noteValue,
    required this.value,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(border: boxBorder, color: color),
        alignment: Alignment.center,
        child: noteValue != null && noteValue!.isNotEmpty
            ? SudokuNoteCell(noteValue!)
            : SudokuNormalCell(value, textColor),
      ),
    );
  }
}

class SudokuNoteCell extends StatelessWidget {
  final List<int> values;

  const SudokuNoteCell(this.values, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$values",
      style: const TextStyle(fontSize: 8),
      textAlign: TextAlign.start,
    );
  }
}

class SudokuNormalCell extends StatelessWidget {
  final int value;
  final Color? color;

  const SudokuNormalCell(this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value == 0 ? "" : value.toString(),
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: color),
    );
  }
}
