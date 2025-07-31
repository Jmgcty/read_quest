import 'package:flutter/material.dart';
import 'package:read_quest/theme/elevated_button_theme.dart';
import 'package:read_quest/theme/input_theme.dart';
import 'package:read_quest/theme/text_theme.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    inputDecorationTheme: appInputTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    textTheme: appTextTheme,
  );
}
