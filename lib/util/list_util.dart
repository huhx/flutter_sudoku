import 'package:flutter/material.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/theme/color.dart';

class ListUtil {
  static List<Point> lists = [
    const Point(x: 0, y: 0),
    const Point(x: 0, y: 1),
    const Point(x: 0, y: 2),
    const Point(x: 1, y: 0),
    const Point(x: 1, y: 1),
    const Point(x: 1, y: 2),
    const Point(x: 2, y: 0),
    const Point(x: 2, y: 1),
    const Point(x: 2, y: 2),
  ];

  static List<Point> match(List<List<int>> lists, Point point) {
    final int row = point.x;
    final int column = point.y;

    if (lists[row][column] == 0) {
      return [];
    }
    List<Point> points = [];
    for (int i = 0; i < lists.length; i++) {
      for (int j = 0; j < lists[i].length; j++) {
        if ((i != row && j != column) && lists[row][column] == lists[i][j]) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  static Map<Point, Color?> highlight(List<List<int>> lists, Point point) {
    final List<Point> matchedPoints = match(lists, point);
    return {for (var point in matchedPoints) point: highlightColor};
  }
}
