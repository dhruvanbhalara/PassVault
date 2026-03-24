import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/locale/locale_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

import 'config/routes/app_router.dart';
import 'core/design_system/theme/theme.dart';
import 'core/di/injection.dart';

class PassVaultApp extends StatefulWidget {
  const PassVaultApp({super.key});

  @override
  State<PassVaultApp> createState() => _PassVaultAppState();
}

class _PassVaultAppState extends State<PassVaultApp> {
  late final AppLifecycleListener _lifecycleListener;

  // True when the app is inactive (moving to background / app-switcher).
  // Flutter renders a full-black frame at this state so the OS snapshot
  // captures black instead of vault content.
  bool _showPrivacyScreen = false;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onInactive: () => setState(() => _showPrivacyScreen = true),
      onResume: () => setState(() => _showPrivacyScreen = false),
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<LocaleBloc>()),
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

          final locale = context.watch<LocaleBloc>().state.locale;

          return Stack(
            textDirection: TextDirection.ltr,
            children: [
              MaterialApp.router(
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
              ),
              // Privacy screen: covers Flutter's rendering surface when the app
              // is inactive so the OS app-switcher snapshot captures black.
              if (_showPrivacyScreen)
                const ColoredBox(color: Colors.black, child: SizedBox.expand()),
            ],
          );
        },
      ),
    );
  }
}
