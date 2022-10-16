import 'package:flutter_sudoku/model/sudoku.dart';

class ListUtil {
  static List<Point> match(List<List<int>> lists, int value) {
    List<Point> points = [];
    for (int i = 0; i < lists.length; i++) {
      for (int j = 0; j < lists[i].length; j++) {
        if (value == lists[i][j]) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }
}
