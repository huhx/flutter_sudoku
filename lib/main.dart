import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'business/home/home_screen.dart';
import 'business/main/theme_provider.dart';
import 'component/custom_load_footer.dart';
import 'component/custom_water_drop_header.dart';
import 'theme/theme.dart';
import 'util/app_config.dart';
import 'util/comm_util.dart';
import 'util/prefs_util.dart';

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
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
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
          child: const HomeScreen(),
        ),
        theme: appThemeData[AppTheme.light],
        darkTheme: appThemeData[AppTheme.dark],
        themeMode: ref.watch(themeProvider).themeMode,
      ),
    );
  }
}
