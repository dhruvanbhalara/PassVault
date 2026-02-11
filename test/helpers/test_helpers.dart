import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/l10n/app_localizations.dart';

export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:mocktail/mocktail.dart';
export 'package:passvault/core/design_system/theme/app_colors.dart';
export 'package:passvault/core/design_system/theme/app_dimensions.dart';
export 'package:passvault/core/design_system/theme/app_theme.dart';
export 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
export 'package:passvault/l10n/app_localizations.dart';

Widget createTestWidget({
  required Widget child,
  ThemeData? theme,
  List<NavigatorObserver> navigatorObservers = const [],
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    navigatorObservers: navigatorObservers,
    home: Scaffold(body: child),
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ThemeData? theme,
    List<NavigatorObserver> navigatorObservers = const [],
    bool usePumpAndSettle = true,
  }) async {
    await pumpWidget(
      createTestWidget(
        child: widget,
        theme: theme,
        navigatorObservers: navigatorObservers,
      ),
    );
    if (usePumpAndSettle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }
}

Future<AppLocalizations> getL10n() async {
  return await AppLocalizations.delegate.load(const Locale('en'));
}
