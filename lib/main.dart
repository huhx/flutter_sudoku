import 'dart:async';
import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sudoku/business/home/sudoku_screen.dart';
import 'package:flutter_sudoku/common/string_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uni_links/uni_links.dart';

import 'business/main/theme_provider.dart';
import 'component/custom_load_footer.dart';
import 'component/custom_water_drop_header.dart';
import 'theme/theme.dart';
import 'util/app_config.dart';
import 'util/comm_util.dart';
import 'util/prefs_util.dart';

bool _initialUriIsHandled = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsUtil.init();
  await _initApplicationPath();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

Future<void> _initApplicationPath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  AppConfig.save("applicationPath", directory.path);
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  Uri? _initialUri, _latestUri;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      print('got uri: $uri');
      setState(() => _latestUri = uri);
    }, onError: (Object err) {
      if (!mounted) return;
      print('got err: $err');
      setState(() => _latestUri = null);
    });
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        print('falied to get initial uri');
      } on FormatException catch (_) {
        if (!mounted) return;
        print('malformed initial uri');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => const CustomWaterDropHeader(),
      footerBuilder: () => const CustomLoadFooter(),
      child: MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const CupertinoScrollBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        home: DoubleBack(
          onFirstBackPress: (_) => CommUtil.toast(message: "再按一次退出"),
          child: _buildWidget(),
        ),
        theme: appThemeData[AppTheme.light],
        darkTheme: appThemeData[AppTheme.dark],
        themeMode: ref.watch(themeProvider).themeMode,
      ),
    );
  }

  Widget _buildWidget() {
    if (_initialUri != null) {
      final queryParams = _initialUri?.queryParametersAll.entries.toList();
      final DateTime dateTime = queryParams![0].value[0].toDate();
      final Difficulty difficulty = Difficulty.from(queryParams[1].value[0].toInt());

      return SudokuScreen(dateTime, difficulty);
    }

    if (_latestUri != null) {
      final queryParams = _latestUri?.queryParametersAll.entries.toList();
      final DateTime dateTime = queryParams![0].value[0].toDate();
      final Difficulty difficulty = Difficulty.from(queryParams[1].value[0].toInt());

      return SudokuScreen(dateTime, difficulty);
    }
    return SudokuScreen(DateTime.now(), Difficulty.a);
  }
}
