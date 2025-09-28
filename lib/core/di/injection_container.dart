// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:stocksapp/core/navigation/app_router.dart';
import 'package:stocksapp/core/themes/app_theme.dart';
import 'package:stocksapp/presentation/blocs/theme/theme_cubit.dart';

final getIt = GetIt.instance;

void init() {
  // Регистрируем зависимости вручную
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());
}
