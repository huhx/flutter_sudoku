import 'package:flutter_sudoku/model/sudoku_point.dart';

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

  static Set<Point> related(Point selected) {
    final int timeX = (selected.x / 3).floor();
    final int timeY = (selected.y / 3).floor();

    return lists.map((point) => Point(x: point.x + timeX * 3, y: point.y + timeY * 3)).toSet();
  }
}
