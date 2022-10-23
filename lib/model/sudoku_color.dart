import 'package:flutter/material.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/theme/color.dart';

class SudokuColor {
  Point selected;
  List<Point> highlightPoints;
  List<Point> relatedPoints;
  Map<Point, Color> textColorMap;

  SudokuColor({
    required this.selected,
    required this.highlightPoints,
    required this.relatedPoints,
    required this.textColorMap,
  });

  Color? getTextColor(Point point) {
    return textColorMap[point];
  }

  void putTextColor(Point point, Color color) {
    textColorMap[point] = color;
  }

  void putReleatedColor(List<Point> relatedPoints) {
    this.relatedPoints = relatedPoints;
  }

  void putHighlightColor(List<Point> highlightPoints) {
    this.highlightPoints = highlightPoints;
  }

  void update({
    required Point selected,
    required List<Point> highlightPoints,
    required List<Point> relatedPoints,
  }) {
    this.selected = selected;
    this.highlightPoints = highlightPoints;
    this.relatedPoints = relatedPoints;
  }

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
}
