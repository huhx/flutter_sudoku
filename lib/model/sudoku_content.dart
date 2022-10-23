import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/common/list_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/theme/color.dart';

import 'sudoku_color.dart';
import 'sudoku_point.dart';

class Sudoku {
  Point selected;
  final List<List<int>> question;
  final List<List<int>> content;
  final List<List<int>> answer;
  final Map<Point, List<int>?> notesMap;
  bool enableNotes;
  final Difficulty difficulty;
  final String dateTime;
  late SudokuColor sudokuColor;

  Sudoku({
    required this.selected,
    required this.question,
    required this.content,
    required this.answer,
    required this.notesMap,
    required this.enableNotes,
    required this.difficulty,
    required this.dateTime,
  });

  void setSelected(Point point) {
    selected = point;
    sudokuColor.update(
      selected: point,
      highlightPoints: highlight(),
      relatedPoints: related(),
    );
  }

  void toggleNote() {
    enableNotes = !enableNotes;
  }

  static Sudoku from(SudokuResponse sudokuResponse) {
    return Sudoku(
      selected: Point.first(),
      enableNotes: false,
      question: sudokuResponse.toQuestion(),
      content: sudokuResponse.toQuestion(),
      answer: sudokuResponse.toAnswer(),
      notesMap: {},
      dateTime: sudokuResponse.dateTime,
      difficulty: sudokuResponse.difficulty,
    );
  }

  void initColor() {
    sudokuColor = SudokuColor(
      selected: selected,
      highlightPoints: highlight(),
      relatedPoints: related(),
      textColorMap: {for (var point in empty()) point: inputColor},
    );
  }

  List<Point> empty() {
    List<Point> points = [];
    for (int i = 0; i < question.length; i++) {
      for (int j = 0; j < question[i].length; j++) {
        if (question[i][j] == 0) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  Sudoku update(int value) {
    content[selected.x][selected.y] = value;
    return this;
  }

  int getValue(Point point) {
    return content[point.x][point.y];
  }

  List<int>? getNoteValue(Point point) {
    return notesMap[point];
  }

  void updateNotesMap(int value) {
    final List<int>? list = notesMap[selected];
    if (list == null || list.isEmpty) {
      notesMap[selected] = [value];
    } else {
      notesMap[selected] = list.addOrRemove(value);
    }
  }

  void removeNote() {
    notesMap.remove(selected);
  }

  bool hasValue() {
    return question[selected.x][selected.y] != 0;
  }

  List<List<int>> deepCopy() {
    return question.map((e) => e.toList()).toList();
  }

  bool checkValue() {
    return answer[selected.x][selected.y] == content[selected.x][selected.y];
  }

  bool hasNoValue() {
    return question[selected.x][selected.y] == 0;
  }

  bool isSuccess() {
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        final int actual = content[i][j], expect = answer[i][j];
        if (actual != expect) {
          return false;
        }
      }
    }
    return true;
  }

  int correctValue() {
    return answer[selected.x][selected.y];
  }

  List<SudokuCheck> check() {
    final int length = content.length;
    List<SudokuCheck> result = [];

    for (int i = 0; i < length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        final int actual = content[i][j], expect = answer[i][j];
        if (actual != 0 && actual != expect) {
          result.add(SudokuCheck(x: i, y: j, actual: actual, expect: expect));
        }
      }
    }
    return result;
  }

  List<Point> highlight() {
    if (content[selected.x][selected.y] == 0) {
      return [];
    }
    List<Point> points = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if ((i != selected.x && j != selected.y) && content[selected.x][selected.y] == content[i][j]) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  List<Point> related() {
    List<Point> relatedList = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if (i == selected.x && j == selected.y) {
          continue;
        }
        if (i == selected.x || j == selected.y) {
          relatedList.add(Point.from(i, j));
        }
      }
    }
    return relatedList;
  }
}

class SudokuCheck extends Equatable {
  final int x;
  final int y;
  final int actual;
  final int expect;

  const SudokuCheck({
    required this.x,
    required this.y,
    required this.actual,
    required this.expect,
  });

  @override
  List<Object?> get props => [x, y, actual, expect];
}
