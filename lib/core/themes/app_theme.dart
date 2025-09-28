// lib/core/themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2563EB),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF64748B),
    ),
    fontFamily: 'Inter',
    useMaterial3: true,
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3B82F6),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF94A3B8),
    ),
    fontFamily: 'Inter',
    useMaterial3: true,
  );
}
