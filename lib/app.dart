import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/locale/locale_cubit.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

import 'config/routes/app_router.dart';
import 'core/design_system/theme/theme.dart';
import 'core/di/injection.dart';

class PassVaultApp extends StatelessWidget {
  const PassVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => LocaleCubit()),
      ],
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

          final locale = context.watch<LocaleCubit>().state;

          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            theme: theme,
            darkTheme: darkThemeData ?? theme,
            themeMode: themeMode,
            routerConfig: getIt<AppRouter>().config,
          );
        },
      ),
    );
  }
}
