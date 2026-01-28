import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/widgets/password_preview_card.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

void main() {
  late MockGeneratePasswordUseCase mockUseCase;

  setUpAll(() {
    mockUseCase = MockGeneratePasswordUseCase();
    getIt.registerSingleton<GeneratePasswordUseCase>(mockUseCase);
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('$PasswordPreviewCard', () {
    testWidgets('renders preview password from use case', (
      WidgetTester tester,
    ) async {
      const settings = PasswordGenerationSettings(length: 12);
      when(
        () => mockUseCase.call(
          length: any(named: 'length'),
          useNumbers: any(named: 'useNumbers'),
          useSpecialChars: any(named: 'useSpecialChars'),
          useUppercase: any(named: 'useUppercase'),
          useLowercase: any(named: 'useLowercase'),
          excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
        ),
      ).thenReturn('MockPassword123');

      await tester.pumpWidget(
        wrapWithMaterial(const PasswordPreviewCard(settings: settings)),
      );

      expect(find.text('MockPassword123'), findsOneWidget);
    });

    testWidgets('refreshes password when refresh icon is tapped', (
      WidgetTester tester,
    ) async {
      const settings = PasswordGenerationSettings(length: 12);
      when(
        () => mockUseCase.call(
          length: any(named: 'length'),
          useNumbers: any(named: 'useNumbers'),
          useSpecialChars: any(named: 'useSpecialChars'),
          useUppercase: any(named: 'useUppercase'),
          useLowercase: any(named: 'useLowercase'),
          excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
        ),
      ).thenReturn('FirstPass');

      await tester.pumpWidget(
        wrapWithMaterial(const PasswordPreviewCard(settings: settings)),
      );

      expect(find.text('FirstPass'), findsOneWidget);

      when(
        () => mockUseCase.call(
          length: any(named: 'length'),
          useNumbers: any(named: 'useNumbers'),
          useSpecialChars: any(named: 'useSpecialChars'),
          useUppercase: any(named: 'useUppercase'),
          useLowercase: any(named: 'useLowercase'),
          excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
        ),
      ).thenReturn('RefreshedPass');

      await tester.tap(find.byIcon(LucideIcons.refreshCw));
      await tester.pump();

      expect(find.text('RefreshedPass'), findsOneWidget);
    });
  });
}
