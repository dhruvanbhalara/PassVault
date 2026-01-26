import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/password_length_card.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  late MockSettingsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(LoadSettings());
  });

  setUp(() {
    mockBloc = MockSettingsBloc();
    when(() => mockBloc.state).thenReturn(const SettingsState());
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<SettingsBloc>.value(value: mockBloc, child: child),
      ),
    );
  }

  group('$PasswordLengthCard', () {
    testWidgets('renders length and slider correctly', (
      WidgetTester tester,
    ) async {
      const settings = PasswordGenerationSettings(length: 32);

      await tester.pumpWidget(
        wrapWithMaterial(const PasswordLengthCard(settings: settings)),
      );

      expect(find.text('Password Length'), findsOneWidget);
      expect(find.text('32'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('adds UpdatePasswordSettings event when slider is moved', (
      WidgetTester tester,
    ) async {
      const settings = PasswordGenerationSettings(length: 12);

      await tester.pumpWidget(
        wrapWithMaterial(const PasswordLengthCard(settings: settings)),
      );

      await tester.drag(find.byType(Slider), const Offset(50, 0));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(any(that: isA<UpdatePasswordSettings>())),
      ).called(greaterThan(0));
    });
  });
}
