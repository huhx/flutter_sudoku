import 'package:flutter_sudoku/common/list_extension.dart';

import 'sudoku_point.dart';

class SudokuContent {
  final List<List<int>> content;
  final Map<Point, List<int>?> notesMap;

  const SudokuContent({required this.content, required this.notesMap});

  SudokuContent update(Point point, int value) {
    content[point.x][point.y] = value;
    return this;
  }

  int getValue(Point point) {
    return content[point.x][point.y];
  }

  List<int>? getNoteValue(Point point) {
    return notesMap[point];
  }

  void updateNotesMap(Point point, int value) {
    final List<int>? list = notesMap[point];
    if (list == null || list.isEmpty) {
      notesMap[point] = [value];
    } else {
      notesMap[point] = list.addOrRemove(value);
    }
  }

  void removeNote(Point point) {
    notesMap.remove(point);
  }

  List<Point> highlight(Point point) {
    if (content[point.x][point.y] == 0) {
      return [];
    }
    List<Point> points = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if ((i != point.x && j != point.y) && content[point.x][point.y] == content[i][j]) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  List<Point> related(Point point) {
    List<Point> relatedList = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if (i == point.x && j == point.y) {
          continue;
        }
        if (i == point.x || j == point.y) {
          relatedList.add(Point.from(i, j));
        }
      }
    }
    return relatedList;
  }
}
