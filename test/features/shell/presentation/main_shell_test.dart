import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/shell/presentation/main_shell.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

void main() {
  late MockThemeBloc mockThemeBloc;

  setUp(() {
    mockThemeBloc = MockThemeBloc();

    when(() => mockThemeBloc.state).thenReturn(
      const ThemeLoaded(themeType: ThemeType.light, themeMode: ThemeMode.light),
    );
  });

  Widget buildRouterApp({String initialLocation = '/a'}) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BlocProvider<ThemeBloc>.value(
              value: mockThemeBloc,
              child: MainShell(navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/a',
                  builder: (context, state) => const Text('Vault'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/b',
                  builder: (context, state) => const Text('Generator'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/c',
                  builder: (context, state) => const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  group('$MainShell', () {
    testWidgets('renders all navigation items', (tester) async {
      await tester.pumpWidget(buildRouterApp());
      await tester.pumpAndSettle();

      expect(find.byType(Icon), findsNWidgets(3));
      expect(find.text('Vault'), findsOneWidget);
    });

    testWidgets('switches tabs on tap', (tester) async {
      await tester.pumpWidget(buildRouterApp());
      await tester.pumpAndSettle();

      // Tap Generator tab
      await tester.tap(find.byType(Icon).at(1));
      await tester.pumpAndSettle();

      expect(find.text('Generator'), findsOneWidget);

      // Tap Settings tab
      await tester.tap(find.byType(Icon).at(2));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('dynamic decoration matches AMOLED theme', (tester) async {
      when(() => mockThemeBloc.state).thenReturn(
        const ThemeLoaded(
          themeType: ThemeType.amoled,
          themeMode: ThemeMode.dark,
        ),
      );

      await tester.pumpWidget(buildRouterApp());
      await tester.pumpAndSettle();

      final decoratedBox = find
          .descendant(
            of: find.byType(Scaffold),
            matching: find.byType(DecoratedBox),
          )
          .first;

      final decoration =
          tester.widget<DecoratedBox>(decoratedBox).decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('renders dark theme decoration', (tester) async {
      when(() => mockThemeBloc.state).thenReturn(
        const ThemeLoaded(themeType: ThemeType.dark, themeMode: ThemeMode.dark),
      );

      await tester.pumpWidget(buildRouterApp());
      await tester.pumpAndSettle();

      final decoratedBox = find
          .descendant(
            of: find.byType(Scaffold),
            matching: find.byType(DecoratedBox),
          )
          .first;

      final decoration =
          tester.widget<DecoratedBox>(decoratedBox).decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });
}
