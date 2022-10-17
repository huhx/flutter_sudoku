import 'package:flutter_sudoku/model/sudoku.dart';

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

  static List<Point> empty(List<List<int>> lists) {
    List<Point> points = [];
    for (int i = 0; i < lists.length; i++) {
      for (int j = 0; j < lists[i].length; j++) {
        if (lists[i][j] == 0) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  static bool check(List<List<int>> content, List<List<int>> answer) {
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

  static Set<Point> related(int x, int y) {
    final int timeX = (x / 3).floor();
    final int timeY = (y / 3).floor();

    return lists.map((point) => Point(x: point.x + timeX * 3, y: point.y + timeY * 3)).toSet();
  }
}
