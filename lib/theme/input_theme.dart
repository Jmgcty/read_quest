import 'package:flutter/material.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';

const appInputTheme = InputDecorationTheme(
  errorStyle: TextStyle(color: AppColors.error),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(AppBorderSettings.borderRadius),
    ),
    borderSide: BorderSide(color: AppColors.error, width: 2),
  ),

  focusColor: AppColors.primary,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(AppBorderSettings.borderRadius),
    ),
    borderSide: BorderSide(color: AppColors.primary, width: 2),
  ),
  labelStyle: TextStyle(color: AppColors.textLabel),
  floatingLabelStyle: TextStyle(color: AppColors.textLabel),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(AppBorderSettings.borderRadius),
    ),
    borderSide: BorderSide(color: AppColors.textLabel, width: 2),
  ),
);
