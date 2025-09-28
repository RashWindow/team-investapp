import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void initTheme() {
    emit(const ThemeState(themeMode: AppThemeMode.system));
  }

  void toggleTheme() {
    final newThemeMode = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    emit(ThemeState(themeMode: newThemeMode));
  }

  void setTheme(AppThemeMode themeMode) {
    emit(ThemeState(themeMode: themeMode));
  }

  ThemeMode get flutterThemeMode {
    switch (state.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
