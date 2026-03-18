import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/get_password_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password/add_edit_password_bloc.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';
import 'package:password_engine/password_engine.dart' hide PasswordFeedback;

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

class MockEstimatePasswordStrengthUseCase extends Mock
    implements EstimatePasswordStrengthUseCase {}

class MockGetPasswordGenerationSettingsUseCase extends Mock
    implements GetPasswordGenerationSettingsUseCase {}

class MockGetPasswordUseCase extends Mock implements GetPasswordUseCase {}

class MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

void main() {
  late AddEditPasswordBloc bloc;
  late MockGeneratePasswordUseCase mockGeneratePasswordUseCase;
  late MockEstimatePasswordStrengthUseCase mockEstimateStrengthUseCase;
  late MockGetPasswordGenerationSettingsUseCase mockGetSettingsUseCase;
  late MockSavePasswordUseCase mockSavePasswordUseCase;
  late MockGetPasswordUseCase mockGetPasswordUseCase;

  setUpAll(() {
    registerFallbackValue(
      const PasswordGenerationStrategy(
        id: 'fallback',
        name: 'Fallback',
        length: 16,
      ),
    );
  });

  setUp(() {
    mockGeneratePasswordUseCase = MockGeneratePasswordUseCase();
    mockEstimateStrengthUseCase = MockEstimatePasswordStrengthUseCase();
    mockGetSettingsUseCase = MockGetPasswordGenerationSettingsUseCase();
    mockSavePasswordUseCase = MockSavePasswordUseCase();
    mockGetPasswordUseCase = MockGetPasswordUseCase();

    // Stub default settings to avoid failures during Bloc initialization
    when(() => mockGetSettingsUseCase()).thenReturn(
      const Success(
        PasswordGenerationSettings(
          strategies: [
            PasswordGenerationStrategy(
              id: 'default',
              name: 'Default',
              length: 16,
            ),
          ],
          defaultStrategyId: 'default',
        ),
      ),
    );

    bloc = AddEditPasswordBloc(
      mockGeneratePasswordUseCase,
      mockEstimateStrengthUseCase,
      mockGetSettingsUseCase,
      mockSavePasswordUseCase,
      mockGetPasswordUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('$AddEditPasswordBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, isA<AddEditInitial>());
      expect(bloc.state.strength, const PasswordFeedback.empty());
      expect(bloc.state.generatedPassword, '');
    });

    group('$PasswordChanged', () {
      test('updates strength when password changes', () async {
        const feedback = PasswordFeedback(strength: PasswordStrength.medium);
        when(() => mockEstimateStrengthUseCase('test123')).thenReturn(feedback);

        bloc.add(const PasswordChanged('test123'));
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.strength, feedback);
      });

      test('resets status to initial when password changes manually', () async {
        const feedback = PasswordFeedback(strength: PasswordStrength.strong);
        when(() => mockEstimateStrengthUseCase(any())).thenReturn(feedback);
        final settings = const PasswordGenerationSettings(
          strategies: [
            PasswordGenerationStrategy(
              id: 'default',
              name: 'Default',
              length: 16,
            ),
          ],
          defaultStrategyId: 'default',
        );
        when(() => mockGetSettingsUseCase()).thenReturn(Success(settings));
        when(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).thenReturn('GeneratedPass123!');

        // First, generate a password
        bloc.add(const GenerateStrongPassword());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state, isA<AddEditGenerated>());
        expect(bloc.state.generatedPassword, 'GeneratedPass123!');

        // Now, user types manually - status should reset to initial
        bloc.add(const PasswordChanged('MyManualPassword'));
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state, isA<AddEditInitial>());
        expect(bloc.state.strength, feedback);
      });

      test('strength updates correctly for different passwords', () async {
        const weakFeedback = PasswordFeedback(strength: PasswordStrength.weak);
        const strongFeedback = PasswordFeedback(
          strength: PasswordStrength.veryStrong,
        );
        when(
          () => mockEstimateStrengthUseCase('weak'),
        ).thenReturn(weakFeedback);
        when(
          () => mockEstimateStrengthUseCase('StrongPassword123!'),
        ).thenReturn(strongFeedback);

        // Test weak password
        bloc.add(const PasswordChanged('weak'));
        await Future.delayed(const Duration(milliseconds: 50));
        expect(bloc.state.strength, weakFeedback);

        // Test strong password
        bloc.add(const PasswordChanged('StrongPassword123!'));
        await Future.delayed(const Duration(milliseconds: 50));
        expect(bloc.state.strength, strongFeedback);
      });
    });

    group('$GenerateStrongPassword', () {
      test('generates password and updates state', () async {
        final settings = const PasswordGenerationSettings(
          strategies: [
            PasswordGenerationStrategy(
              id: 'default',
              name: 'Default',
              length: 16,
            ),
          ],
          defaultStrategyId: 'default',
        );
        when(() => mockGetSettingsUseCase()).thenReturn(Success(settings));
        when(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).thenReturn('SecurePassword123!');
        const feedback = PasswordFeedback(strength: PasswordStrength.strong);
        when(
          () => mockEstimateStrengthUseCase('SecurePassword123!'),
        ).thenReturn(feedback);

        bloc.add(const GenerateStrongPassword());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state, isA<AddEditGenerated>());
        expect(bloc.state.generatedPassword, 'SecurePassword123!');
        expect(bloc.state.strength, feedback);
      });

      test('uses default settings when no saved settings', () async {
        final settings = const PasswordGenerationSettings(
          strategies: [
            PasswordGenerationStrategy(
              id: 'default',
              name: 'Default',
              length: 16,
            ),
          ],
          defaultStrategyId: 'default',
        );
        when(() => mockGetSettingsUseCase()).thenReturn(Success(settings));
        when(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).thenReturn('DefaultPassword!');
        const feedback = PasswordFeedback(strength: PasswordStrength.strong);
        when(
          () => mockEstimateStrengthUseCase('DefaultPassword!'),
        ).thenReturn(feedback);

        bloc.add(const GenerateStrongPassword());
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).called(1);
      });
    });
  });
}
