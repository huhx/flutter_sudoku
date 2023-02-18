import 'dart:async';
import 'dart:io';

import 'package:app_common_flutter/app_common_flutter.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deep_links/flutter_deep_links.dart';
import 'package:flutter_sudoku/business/home/sudoku_screen.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'api/sudoku_api.dart';
import 'api/sudoku_record_api.dart';
import 'provider/theme_provider.dart';
import 'service/audio_service.dart';
import 'theme/theme.dart';
import 'util/prefs_util.dart';

bool _initialUriIsHandled = false;
final Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsUtil.init();
  await _initApplicationPath();
  _initServices();
  await initPackageInfo();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

void _initServices() {
  GetIt.I.registerLazySingleton<AudioService>(() => AudioService());
  GetIt.I.registerLazySingleton<SudokuApi>(() => SudokuApi());
  GetIt.I.registerLazySingleton<SudokuRecordApi>(() => SudokuRecordApi());
}

Future<void> _initApplicationPath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  AppConfig.save("applicationPath", directory.path);
}

Future<void> initPackageInfo() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  AppConfig.save("version", version);
  AppConfig.save("buildNumber", buildNumber);
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  Uri? _initialUri, _latestUri;
  StreamSubscription? _sub;
  final FlutterDeepLinks flutterDeepLinks = FlutterDeepLinks();

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
    _sub = flutterDeepLinks.uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      logger.d('got uri: $uri');
      setState(() => _latestUri = uri);
    }, onError: (Object err) {
      if (!mounted) return;
      logger.d('got err: $err');
      setState(() => _latestUri = null);
    });
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await flutterDeepLinks.getInitialUri();
        if (uri == null) {
          logger.d('no initial uri');
        } else {
          logger.d('got initial uri: $uri');
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        logger.d('failed to get initial uri');
      } on FormatException catch (_) {
        if (!mounted) return;
        logger.d('malformed initial uri');
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
        themeMode: ref.watch(themeProvider),
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
    return SudokuScreen(DateTime.now(), Difficulty.d);
  }
}
