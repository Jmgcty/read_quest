import 'package:flutter/material.dart';
import 'package:read_quest/core/const/app_border_settings.dart';

const appInputTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(AppBorderSettings.borderRadius),
    ),
  ),
);
