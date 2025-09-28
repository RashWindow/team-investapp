// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksapp/core/di/injection_container.dart';
import 'package:stocksapp/core/themes/app_theme.dart';
import 'package:stocksapp/presentation/blocs/theme/theme_cubit.dart';
import 'package:stocksapp/core/navigation/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:window_manager/window_manager.dart'; // Добавляем импорт

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Установка минимального размера окна для desktop
  await _setWindowMinSize();

  await EasyLocalization.ensureInitialized();
  init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: MyApp(),
    ),
  );
}

Future<void> _setWindowMinSize() async {
  // Для Windows/Linux/MacOS устанавливаем минимальный размер окна
  try {
    await windowManager.ensureInitialized();
    const minSize = Size(400, 600); // Минимальный размер
    await windowManager.setMinimumSize(minSize);

    // Опционально: установить начальный размер
    await windowManager.setSize(const Size(800, 600));
    await windowManager.center();
  } catch (e) {
    // Игнорируем ошибки на мобильных платформах
    print('Window size setting not available: $e');
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeCubit>()..initTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'app_title'.tr(),
            theme: getIt<AppTheme>().lightTheme,
            darkTheme: getIt<AppTheme>().darkTheme,
            themeMode: context.read<ThemeCubit>().flutterThemeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: _appRouter.config,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
