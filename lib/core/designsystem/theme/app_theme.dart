import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_status_colors.dart';
import 'app_typography.dart';

ThemeData appTheme() {
  final scheme = const ColorScheme.dark(
    primary: blue500,
    onPrimary: white,
    secondary: blue300,
    surface: ink800,
    onSurface: white,
    surfaceContainerHighest: ink700,
    onSurfaceVariant: ink200,
    error: red500,
    outline: ink600,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: ink900,
    textTheme: appTextTheme.apply(bodyColor: white, displayColor: white),
    extensions: const [AppStatusColors.dark],
  );
}
