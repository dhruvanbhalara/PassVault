import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

import 'config/routes/app_router.dart';
import 'core/design_system/theme/theme.dart';
import 'core/di/injection.dart';

class PassVaultApp extends StatelessWidget {
  const PassVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final (theme, darkThemeData, themeMode) = switch (state) {
            ThemeLoaded(:final themeType, :final themeMode) => (
              AppTheme.getTheme(
                themeType == ThemeType.system ? ThemeType.light : themeType,
              ),
              themeType == ThemeType.system
                  ? AppTheme.getTheme(ThemeType.dark)
                  : null,
              themeMode,
            ),
          };

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
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
