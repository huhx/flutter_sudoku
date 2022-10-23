import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Point extends Equatable {
  final int x;
  final int y;

  const Point({required this.x, required this.y});

  factory Point.first() {
    return const Point(x: 0, y: 0);
  }

  factory Point.from(int x, int y) {
    return Point(x: x, y: y);
  }

  BoxBorder get border {
    const BorderSide borderSide = BorderSide(color: Colors.blue, width: 2.0);
    final List<int> columnIndexes = [0, 3, 6];
    final List<int> rowIndexes = [0, 3, 6];
    BorderSide top = BorderSide.none, bottom = BorderSide.none, left = BorderSide.none, right = BorderSide.none;

    if (columnIndexes.contains(y)) {
      left = borderSide;
    } else {
      left = const BorderSide(color: Colors.grey);
    }

    if (rowIndexes.contains(x)) {
      top = borderSide;
    } else {
      top = const BorderSide(color: Colors.grey);
    }

    if (y == 8) {
      right = borderSide;
    }

    if (x == 8) {
      bottom = borderSide;
    }

    return Border(top: top, bottom: bottom, left: left, right: right);
  }

  @override
  List<Object?> get props => [x, y];
}
