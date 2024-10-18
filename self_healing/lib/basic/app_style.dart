import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'dart:ui' as ui;

import '../toolkit/log.dart';

/// App UI Style
class AppStyle {
  static AppStyle? _shared;
  static AppStyle get shared {
    _shared ??= (() {
      return AppStyle._internal();
    })();
    return _shared!;
  }

  AppStyle._internal() {
    init();
  }

  init() {
    log_("AppStyle init");
    // ui.PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
    //   EasyDebounce.debounce(
    //       'onPlatformBrightnessChanged', // <-- An ID for this particular debouncer
    //       const Duration(milliseconds: 100), // <-- The debounce duration
    //       resetBrightness // <-- The target method
    //       );
    // };
    resetBrightness();
  }

  resetBrightness() {
    // AppStyle.isDark.value =
    //     ui.PlatformDispatcher.instance.platformBrightness == Brightness.dark;

    // log_("onPlatformBrightnessChanged dark : ${AppStyle.isDark.value}");
    // if (AppStyle.isDark.value != isDark) {
    //   AppStyle.isDark.value = isDark;
    // }
  }
  static double sizeBoxPadding = 15;
  static double horizontalPadding = 20;
  static double imgCornerRadius = 8.0;
  static double btnCornerRadius = 14.0;
  static double cardCornerRadius = 14.0;
  static Color tintColorForLight = const Color.fromARGB(255, 8, 8, 8);
  static Color tintColorForDark = Colors.white;

  static Color tintColor(bool isDark) {
    return isDark ? tintColorForDark : tintColorForLight;
  }

  static Color borderLineColor(bool isDark) {
    return isDark
        ? Color.fromARGB(255, 167, 167, 167)
        : Color.fromARGB(255, 77, 77, 77);
  }

  static var isDark = false.obs;

  static Color get background1Color {
    return isDark.value ? const Color.fromARGB(255, 39, 36, 36) : Colors.white;
  }

  static Color get backgroundColor {
    return isDark.value
        ? Colors.black
        : const Color.fromARGB(255, 241, 244, 247);
  }

  static Color themeColor = Color.fromARGB(255, 4, 239, 117);

  ThemeData? _light;
  // app 初始化解阶段调用
  ThemeData get light {
    log_("light theme init");
    _light ??= (() {
      final theme = ThemeData(
        fontFamily: "Heiti",
        primaryColor: AppStyle.themeColor,
        brightness: Brightness.light,
        elevatedButtonTheme: _elevatedButtonThemeData(false),
        filledButtonTheme: _filledButtonThemeData(),
        iconTheme: IconThemeData(color: AppStyle.tintColor(false)),
        appBarTheme: _appBarTheme(false),
        scaffoldBackgroundColor: _backgroundColor(false),
        useMaterial3: true,
      );
      return theme;
    })();
    return _light!;
  }

  ThemeData? _dark;
  ThemeData get dark {
    log_("dark theme init");
    _dark ??= (() {
      final theme = ThemeData(
        fontFamily: "Heiti",
        primaryColor: AppStyle.themeColor,
        brightness: Brightness.dark,
        elevatedButtonTheme: _elevatedButtonThemeData(true),
        filledButtonTheme: _filledButtonThemeData(),
        iconTheme: IconThemeData(color: AppStyle.tintColor(true)),
        appBarTheme: _appBarTheme(true),
        scaffoldBackgroundColor: _backgroundColor(true),
        useMaterial3: true,
      );
      return theme;
    })();

    return _dark!;
  }

  // Color _themeColor() {
  //   return const Color.fromARGB(255, 4, 239, 117);
  // }

  Color _backgroundColor(bool isDark) {
    return isDark ? Colors.black : const Color.fromARGB(255, 241, 244, 247);
  }

  ElevatedButtonThemeData _elevatedButtonThemeData(bool isDark) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: AppStyle.themeColor,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        minimumSize: const Size(double.infinity, 54),
        textStyle: AppTextStyle.font18,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppStyle.btnCornerRadius)),
        ),
      ),
    );
  }

  FilledButtonThemeData _filledButtonThemeData() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: AppStyle.themeColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        textStyle: AppTextStyle.font16,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppStyle.btnCornerRadius)),
        ),
      ),
    );
  }

  AppBarTheme _appBarTheme(bool isDark) {
    return AppBarTheme(
        backgroundColor: _backgroundColor(isDark),
        iconTheme: IconThemeData(color: AppStyle.tintColor(isDark)),
        titleTextStyle:
            TextStyle(fontSize: 18, color: AppStyle.tintColor(isDark)));
  }
}

class AppTextStyle extends TextStyle {
  AppTextStyle(
      {super.fontSize, super.fontFamily, super.fontWeight, super.color});

  AppTextStyle copy(
      {double? fontSize,
      String? fontFamily,
      FontWeight? fontWeight,
      Color? color}) {
    return AppTextStyle(
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        fontWeight: fontWeight ?? this.fontWeight,
        color: color ?? this.color);
  }

  AppTextStyle weight200() {
    return copy(fontWeight: FontWeight.w200);
  }

  AppTextStyle weight300() {
    return copy(fontWeight: FontWeight.w300);
  }

  AppTextStyle weight400() {
    return copy(fontWeight: FontWeight.w400);
  }

  AppTextStyle weight500() {
    return copy(fontWeight: FontWeight.w500);
  }

  AppTextStyle weight600() {
    return copy(fontWeight: FontWeight.w600);
  }

  AppTextStyle weight700() {
    return copy(fontWeight: FontWeight.w700);
  }

  AppTextStyle familyHanti() {
    return copy(fontFamily: "Hanti");
  }

  AppTextStyle familyHeiti() {
    return copy(fontFamily: "Heiti");
  }

  static AppTextStyle get font8 {
    return AppTextStyle(
      fontSize: 8.0,
    );
  }

  static AppTextStyle get font10 {
    return AppTextStyle(
      fontSize: 10.0,
    );
  }

  static AppTextStyle get font12 {
    return AppTextStyle(
      fontSize: 12.0,
    );
  }

  static AppTextStyle get font14 {
    return AppTextStyle(
      fontSize: 14.0,
    );
  }

  static AppTextStyle get font16 {
    return AppTextStyle(
      fontSize: 16.0,
    );
  }

  static AppTextStyle get font18 {
    return AppTextStyle(
      fontSize: 18.0,
    );
  }

  static AppTextStyle get font20 {
    return AppTextStyle(
      fontSize: 20.0,
    );
  }

  static AppTextStyle get font22 {
    return AppTextStyle(
      fontSize: 22.0,
    );
  }

  static AppTextStyle get font24 {
    return AppTextStyle(
      fontSize: 24.0,
    );
  }

  static AppTextStyle get font28 {
    return AppTextStyle(
      fontSize: 28.0,
    );
  }

  static AppTextStyle get font32 {
    return AppTextStyle(
      fontSize: 32.0,
    );
  }

  static AppTextStyle get font36 {
    return AppTextStyle(
      fontSize: 36.0,
    );
  }
}
