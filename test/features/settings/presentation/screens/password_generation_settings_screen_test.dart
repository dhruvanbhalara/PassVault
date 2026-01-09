import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_theme.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/password_generation_settings_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {
  @override
  Stream<SettingsState> get stream => Stream.value(state);
}

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

void main() {
  late MockSettingsBloc mockSettingsBloc;
  late MockGeneratePasswordUseCase mockGeneratePasswordUseCase;

  setUpAll(() {
    registerFallbackValue(const PasswordGenerationSettings());
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockGeneratePasswordUseCase = MockGeneratePasswordUseCase();

    // Register dependency for PreviewCard
    if (getIt.isRegistered<GeneratePasswordUseCase>()) {
      getIt.unregister<GeneratePasswordUseCase>();
    }
    getIt.registerSingleton<GeneratePasswordUseCase>(
      mockGeneratePasswordUseCase,
    );
    if (getIt.isRegistered<SettingsBloc>()) {
      getIt.unregister<SettingsBloc>();
    }
    getIt.registerSingleton<SettingsBloc>(mockSettingsBloc);

    when(() => mockSettingsBloc.close()).thenAnswer((_) async {});
    when(
      () => mockGeneratePasswordUseCase(
        length: any(named: 'length'),
        useNumbers: any(named: 'useNumbers'),
        useSpecialChars: any(named: 'useSpecialChars'),
        useUppercase: any(named: 'useUppercase'),
        useLowercase: any(named: 'useLowercase'),
        excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
      ),
    ).thenReturn('MockPass123!');
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: const PasswordGenerationSettingsScreen(),
    );
  }

  testWidgets('Renders PasswordGenerationSettingsScreen', (tester) async {
    when(() => mockSettingsBloc.state).thenReturn(
      const SettingsState(passwordSettings: PasswordGenerationSettings()),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(PasswordGenerationSettingsScreen), findsOneWidget);
    expect(find.text('PASSWORD LENGTH'), findsOneWidget);
  });
}
