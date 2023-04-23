import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { light, dark }

const ColorScheme flexSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xffce5b78),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffe8b5ce),
  onPrimaryContainer: Color(0xff271f23),
  secondary: Color(0xfffbae9d),
  onSecondary: Color(0xff000000),
  secondaryContainer: Color(0xffffdad1),
  onSecondaryContainer: Color(0xff282523),
  tertiary: Color(0xfff39682),
  onTertiary: Color(0xff000000),
  tertiaryContainer: Color(0xffffcfc3),
  onTertiaryContainer: Color(0xff282321),
  error: Color(0xff790000),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfff1d8d8),
  onErrorContainer: Color(0xff282525),
  outline: Color(0xff625c62),
  background: Color(0xfffbf2f4),
  onBackground: Color(0xff131213),
  surface: Color(0xfffdf8f9),
  onSurface: Color(0xff090909),
  surfaceVariant: Color(0xfffbf2f4),
  onSurfaceVariant: Color(0xff131213),
  inverseSurface: Color(0xff181315),
  onInverseSurface: Color(0xfff5f5f5),
  inversePrimary: Color(0xfffff4f9),
  shadow: Color(0xff000000),
);

const ColorScheme flexSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffeec4d8),
  onPrimary: Color(0xff1e1d1e),
  primaryContainer: Color(0xffce5b78),
  onPrimaryContainer: Color(0xffffe5ec),
  secondary: Color(0xfff5d6c6),
  onSecondary: Color(0xff1e1e1d),
  secondaryContainer: Color(0xffeba689),
  onSecondaryContainer: Color(0xff3c2b24),
  tertiary: Color(0xfff7e0d4),
  onTertiary: Color(0xff1e1e1e),
  tertiaryContainer: Color(0xffeebda8),
  onTertiaryContainer: Color(0xff3c312c),
  error: Color(0xffcf6679),
  onError: Color(0xff1e1214),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xfff9dde2),
  outline: Color(0xff989898),
  background: Color(0xff1e1b1c),
  onBackground: Color(0xffe4e4e4),
  surface: Color(0xff171516),
  onSurface: Color(0xfff1f1f1),
  surfaceVariant: Color(0xff1d1a1b),
  onSurfaceVariant: Color(0xffe4e4e4),
  inverseSurface: Color(0xfffefdfd),
  onInverseSurface: Color(0xff0e0e0e),
  inversePrimary: Color(0xff726068),
  shadow: Color(0xff000000),
);

final appThemeData = {
  AppTheme.light: FlexThemeData.light(
    scheme: FlexScheme.sakura,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    appBarOpacity: 0.95,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: false,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use the playground font, add GoogleFonts package and uncomment
    fontFamily: GoogleFonts.lato().fontFamily,
  ).copyWith(
    appBarTheme: const AppBarTheme(centerTitle: true, titleTextStyle: TextStyle(fontSize: 17)),
  ),
  AppTheme.dark: FlexThemeData.dark(
    scheme: FlexScheme.sakura,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 15,
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.90,
    subThemesData: const FlexSubThemesData(blendOnLevel: 30),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use the playground font, add GoogleFonts package and uncomment
    fontFamily: GoogleFonts.lato().fontFamily,
  ).copyWith(
    appBarTheme: const AppBarTheme(centerTitle: true, titleTextStyle: TextStyle(fontSize: 17)),
  ),
};