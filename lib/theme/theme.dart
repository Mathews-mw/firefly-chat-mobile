import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:flutter/material.dart';

final ThemeData theme = ThemeData();

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: AppColors.primary,
  fontFamily: 'Rany',
  scaffoldBackgroundColor: AppColors.neutral900,
);
