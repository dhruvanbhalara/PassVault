import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:passvault/l10n/app_localizations.dart';

import 'config/routes/app_router.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_cubit.dart';

class PassVaultApp extends StatelessWidget {
  const PassVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          ThemeData theme;
          ThemeData? darkThemeData;
          switch (state.themeType) {
            case ThemeType.system:
              theme = AppTheme.getTheme(ThemeType.light);
              darkThemeData = AppTheme.getTheme(ThemeType.dark);
              break;
            case ThemeType.light:
              theme = AppTheme.getTheme(ThemeType.light);
              break;
            case ThemeType.dark:
              theme = AppTheme.getTheme(ThemeType.dark);
              break;
            case ThemeType.amoled:
              theme = AppTheme.getTheme(ThemeType.amoled);
              break;
          }

          return MaterialApp.router(
            title: 'PassVault',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: theme,
            darkTheme: darkThemeData ?? theme,
            themeMode: state.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
