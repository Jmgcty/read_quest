import 'package:flutter/material.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    disabledBackgroundColor: AppColors.disabled,
    disabledForegroundColor: AppColors.textLabel,
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.backgroundWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
    ),
  ),
);
