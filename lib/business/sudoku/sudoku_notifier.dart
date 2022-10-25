import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/list_extension.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  static const List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  late DateTime startTime;
  late List<List<int>> question;
  late List<List<int>> content;
  late List<List<int>> answer;
  late Map<Point, List<int>?> notesMap;
  late Difficulty difficulty;
  late DateTime dateTime;

  late List<Point> highlightPoints;
  late List<Point> relatedPoints;
  late Map<Point, Color> textColorMap;

  late bool enableNotes;
  late Point selected;
  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;
  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    state = ResultState.loading();

    final SudokuResponse sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);

    selected = Point.first();
    startTime = DateTime.now();
    enableNotes = false;
    question = sudokuResponse.toQuestion();
    content = sudokuResponse.toQuestion();
    answer = sudokuResponse.toAnswer();
    notesMap = {};
    this.dateTime = dateTime;
    this.difficulty = sudokuResponse.difficulty;
    gameStatus = GameStatus.running;
    retryCount = 0;
    tipCount = sudokuConfig.tipCount;
    highlightPoints = _highlight();
    relatedPoints = _related();
    textColorMap = {for (final point in _empty()) point: inputColor};

    state = ResultState.success();

    notifyListeners();
  }

  void onTapped(Point point) {
    selected = point;
    relatedPoints = _related();
    highlightPoints = _highlight();

    notifyListeners();
  }

  GameStatus onInput(int value) {
    if (question[selected.x][selected.y] != 0 || _isCorrect) {
      return gameStatus;
    }

    if (enableNotes) {
      final List<int>? list = notesMap[selected];
      if (list == null || list.isEmpty) {
        notesMap[selected] = [value];
      } else {
        notesMap[selected] = list.addOrRemove(value);
      }
      highlightPoints = [];

      notifyListeners();
      return gameStatus;
    }

    notesMap.remove(selected);
    content[selected.x][selected.y] = value;
    relatedPoints = _related();
    highlightPoints = _highlight();

    if (_isNotCorrect) {
      textColorMap[selected] = errorColor;
      if (++retryCount >= sudokuConfig.retryCount) {
        gameStatus = GameStatus.failed;
        saveSudokuRecord();
      }
    } else {
      textColorMap[selected] = inputColor;
      if (_isSuccess()) {
        gameStatus = GameStatus.success;
        saveSudokuRecord();
      }
    }

    notifyListeners();
    return gameStatus;
  }

  void saveSudokuRecord() async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final SudokuRecord sudokuRecord = SudokuRecord(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      difficulty: difficulty,
      gameStatus: gameStatus,
      logStatus: LogStatus.normal,
      duration: ((now - startTime.millisecondsSinceEpoch) / 1000).floor(),
      tipCount: sudokuConfig.retryCount - tipCount,
      errorCount: retryCount,
      startTime: startTime.millisecondsSinceEpoch,
      endTime: now,
      createTime: now,
    );

    await sudokuRecordApi.insert(sudokuRecord);
  }

  void useTip() {
    if (_isNotCorrect) {
      content[selected.x][selected.y] = answer[selected.x][selected.y];
      notesMap.remove(selected);

      relatedPoints = _related();
      highlightPoints = _highlight();
      textColorMap[selected] = inputColor;

      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void clear() {
    if (question[selected.x][selected.y] == 0 && _isNotCorrect) {
      content[selected.x][selected.y] = 0;
      notesMap[selected] = [];
      highlightPoints = [];

      textColorMap[selected] = inputColor;

      notifyListeners();
    }
  }

  void toggleNote() {
    enableNotes = !enableNotes;

    notifyListeners();
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

  Color? getTextColor(Point point) {
    return textColorMap[point];
  }

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/${sudokuConfig.retryCount}";
  }

  Future<void> refresh(DateTime dateTime, Difficulty difficulty) async {
    await init(dateTime, difficulty);
  }

  List<int>? getNoteValue(Point point) {
    return notesMap[point];
  }

  int getValue(Point point) {
    return content[point.x][point.y];
  }

  bool get canUseTip {
    return question[selected.x][selected.y] == 0 && _isNotCorrect;
  }

  bool get canClear {
    bool hasContent = content[selected.x][selected.y] != 0 || _hasNoteValue;
    return question[selected.x][selected.y] == 0 && hasContent && _isNotCorrect;
  }

  bool isEnable(int value) {
    return !_disabledValues.contains(value);
  }

  List<int> get _disabledValues {
    if (question[selected.x][selected.y] != 0 || _isCorrect) {
      return numbers;
    }

    return [content[selected.x][selected.y]];
  }

  bool get _isNotCorrect => !_isCorrect;

  bool get _isCorrect {
    return answer[selected.x][selected.y] == content[selected.x][selected.y];
  }

  bool get _hasNoteValue {
    final List<int>? noteValues = getNoteValue(selected);
    return noteValues != null && noteValues.isNotEmpty;
  }

  bool _isSuccess() {
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

  List<Point> _empty() {
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

  List<Point> _highlight() {
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

  List<Point> _related() {
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

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  return SudokuNotifier()..init(request.dateTime, request.difficulty);
});
