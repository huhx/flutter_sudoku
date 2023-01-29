import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/business/sudoku/base_sudoku.dart';
import 'package:flutter_sudoku/business/sudoku/counter_notifier.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/common/list_extension.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/model/sudoku_input.dart';
import 'package:flutter_sudoku/model/sudoku_input_log.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:flutter_sudoku/model/sudoku_tip.dart';
import 'package:flutter_sudoku/provider/tip_level_provider.dart';
import 'package:flutter_sudoku/service/audio_service.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier with BaseSudoku {
  static const Set<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9};

  late SudokuResponse sudokuResponse;
  late TipLevel tipLevel;

  late DateTime startTime;
  late Difficulty difficulty;
  late DateTime dateTime;
  late List<SudokuInput> sudokuInputs;

  late bool enableNotes;
  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;
  Result state = Result.success();

  final Ref ref;

  SudokuNotifier(this.ref);

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    state = Result.loading();

    sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);

    selected = Point.first();
    startTime = DateTime.now();
    enableNotes = false;
    question = toArray(sudokuResponse.question);
    content = toArray(sudokuResponse.question);
    answer = toArray(sudokuResponse.answer);
    notesMap = {};
    this.dateTime = dateTime;
    this.difficulty = sudokuResponse.difficulty;
    gameStatus = GameStatus.running;
    retryCount = 0;
    tipCount = sudokuConfig.tipCount;
    highlightPoints = highlight();
    relatedPoints = related();
    textColorMap = {for (final point in empty()) point: inputColor};
    sudokuInputs = [];
    tipLevel = ref.read(tipLevelProvider).tipLevel;

    ref.invalidate(counterProvider(0));

    state = Result.success();

    notifyListeners();
  }

  Future<void> reset() async {
    await init(dateTime, difficulty);
  }

  Future<void> next() async {
    final Difficulty? newDifficulty = Difficulty.next(difficulty);
    if (newDifficulty == null) {
      await init(dateTime.previous, Difficulty.d);
    } else {
      await init(dateTime, newDifficulty);
    }
  }

  void onTapped(Point point) {
    selected = point;
    relatedPoints = related();
    highlightPoints = highlight();

    notifyListeners();
  }

  GameStatus onInput(int value) {
    if (question[selected.x][selected.y] != 0 || _isCorrect) {
      return gameStatus;
    }
    audioService.playInput();

    if (enableNotes) {
      final List<int>? list = notesMap[selected];
      if (list == null || list.isEmpty) {
        notesMap[selected] = [value];
      } else {
        notesMap[selected] = list.addOrRemove(value);
      }

      sudokuInputs.add(SudokuInput.inputNote(selected, [...?notesMap[selected]]));
      highlightPoints = [];

      notifyListeners();
      return gameStatus;
    }

    notesMap.remove(selected);
    content[selected.x][selected.y] = value;
    relatedPoints = related();
    highlightPoints = highlight();
    sudokuInputs.add(SudokuInput.inputValue(selected, _isCorrect, value));

    if (_isNotCorrect) {
      textColorMap[selected] = errorColor;
      if (++retryCount >= sudokuConfig.retryCount) {
        gameStatus = GameStatus.failed;
        ref.read(counterProvider(0)).stop();

        _saveSudokuRecord();
        audioService.playFail();
      }
    } else {
      textColorMap[selected] = inputColor;
      if (_isSuccess()) {
        gameStatus = GameStatus.success;

        ref.read(counterProvider(0)).stop();
        _saveSudokuRecord();
        audioService.playSucess();
      }
    }

    notifyListeners();
    return gameStatus;
  }

  void useTip() {
    if (_isNotCorrect) {
      audioService.playOperation();

      content[selected.x][selected.y] = answer[selected.x][selected.y];
      notesMap.remove(selected);

      relatedPoints = related();
      highlightPoints = highlight();
      textColorMap[selected] = inputColor;

      tipCount = tipCount - 1;
      sudokuInputs.add(SudokuInput.inputTip(selected, answer[selected.x][selected.y]));

      notifyListeners();
    }
  }

  void clear() {
    if (question[selected.x][selected.y] == 0 && _isNotCorrect) {
      audioService.playOperation();

      content[selected.x][selected.y] = 0;
      notesMap[selected] = [];
      highlightPoints = [];

      textColorMap[selected] = inputColor;
      sudokuInputs.add(SudokuInput.inputClear(selected));

      notifyListeners();
    }
  }

  void toggleNote() {
    enableNotes = !enableNotes;
    audioService.playOperation();

    notifyListeners();
  }

  String get shareTitle {
    return "huhx://sudoku?dateTime=${dateTime.toDateString()}&difficulty=${difficulty.level}";
  }

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/${sudokuConfig.retryCount}";
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

  Set<int> get _disabledValues {
    if (question[selected.x][selected.y] != 0 || _isCorrect) {
      return numbers;
    }

    final Set<int> disabledNumbers = _disabledNumbers(tipLevel);
    return {content[selected.x][selected.y], ...disabledNumbers};
  }

  Set<int> _disabledNumbers(TipLevel tipLevel) {
    switch (tipLevel) {
      case TipLevel.none:
        return {};
      case TipLevel.first:
        return horizontalSet();
      case TipLevel.second:
        return {...horizontalSet(), ...verticalSet()};
      case TipLevel.third:
        return {...horizontalSet(), ...verticalSet(), ...insideSet()};
    }
  }

  void _saveSudokuRecord() async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final SudokuInputLog sudokuInputLog = SudokuInputLog(
      question: sudokuResponse.question,
      answer: sudokuResponse.answer,
      difficulty: difficulty,
      dateTime: dateTime.millisecondsSinceEpoch,
      gameStatus: gameStatus,
      sudokuInputs: sudokuInputs,
    );
    final SudokuRecord sudokuRecord = SudokuRecord(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      difficulty: difficulty,
      gameStatus: gameStatus,
      logStatus: LogStatus.normal,
      sudokuInputLog: sudokuInputLog,
      duration: ref.read(counterProvider(0)).seconds,
      tipCount: sudokuConfig.tipCount - tipCount,
      errorCount: retryCount,
      startTime: startTime.millisecondsSinceEpoch,
      endTime: now,
      createTime: now,
    );

    await sudokuRecordApi.insert(sudokuRecord);
  }

  String get dateString {
    return ref.read(counterProvider(0)).secondsString;
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

  @override
  void dispose() {
    ref.invalidate(counterProvider(0));
    super.dispose();
  }
}

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  return SudokuNotifier(ref)..init(request.dateTime, request.difficulty);
});
