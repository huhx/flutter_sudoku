import 'package:app_common_flutter/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:flutter_sudoku/util/list_util.dart';

mixin BaseSudoku {
  late List<List<int>> question;
  late List<List<int>> content;
  late List<List<int>> answer;
  late Point selected;

  late Map<Point, List<int>?> notesMap;

  late Map<Point, Color> textColorMap;
  late List<Point> highlightPoints;
  late List<Point> relatedPoints;

  Color? getColor(Point point) {
    if (point == selected) {
      return selectedColor;
    }

    if (highlightPoints.contains(point)) {
      return highlightColor;
    }

    if (relatedPoints.contains(point)) {
      return relatedColor;
    }
    return null;
  }

  Color? getTextColor(Point point) {
    return textColorMap[point];
  }

  List<int>? getNoteValue(Point point) {
    return notesMap[point];
  }

  int getValue(Point point) {
    return content[point.x][point.y];
  }

  int get contentValue => content[selected.x][selected.y];
  int get questionValue => question[selected.x][selected.y];
  int get answerValue => answer[selected.x][selected.y];

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

  List<Point> highlight() {
    if (contentValue == 0) {
      return [];
    }
    List<Point> points = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if ((i != selected.x && j != selected.y) && contentValue == content[i][j]) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  Set<int> horizontalSet() {
    Set<int> result = {};
    for (int i = 0; i < content.length; i++) {
      final int value = content[i][selected.y];
      if (value != 0 && value == answer[i][selected.y]) {
        result.add(value);
      }
    }
    return result;
  }

  Set<int> verticalSet() {
    Set<int> result = {};
    for (int i = 0; i < content.length; i++) {
      final int value = content[selected.x][i];
      if (value != 0 && value == answer[selected.x][i]) {
        result.add(value);
      }
    }
    return result;
  }

  Set<int> insideSet() {
    Set<int> result = {};
    ListUtil.related(selected).forEach((point) {
      final int value = content[point.x][point.y];
      if (value != 0 && value == answer[point.x][point.y]) {
        result.add(value);
      }
    });
    return result;
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

  List<List<int>> toArray(String string) {
    final List<String> firstChunk = string.chunk(9);
    return firstChunk.map((e) => e.split("").map((e) => e.toInt()).toList()).toList();
  }
}
