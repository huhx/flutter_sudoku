import 'package:flutter/material.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({Key? key}) : super(key: key);

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("趣味数独")),
      body: Container(
        alignment: Alignment.center,
        child: const Text("Sudoku Screen"),
      ),
    );
  }
}
