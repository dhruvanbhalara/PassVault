import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

class MockEstimatePasswordStrengthUseCase extends Mock
    implements EstimatePasswordStrengthUseCase {}

class MockGetPasswordGenerationSettingsUseCase extends Mock
    implements GetPasswordGenerationSettingsUseCase {}

class MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

void main() {
  late AddEditPasswordBloc bloc;
  late MockGeneratePasswordUseCase mockGeneratePasswordUseCase;
  late MockEstimatePasswordStrengthUseCase mockEstimateStrengthUseCase;
  late MockGetPasswordGenerationSettingsUseCase mockGetSettingsUseCase;
  late MockSavePasswordUseCase mockSavePasswordUseCase;

  setUp(() {
    mockGeneratePasswordUseCase = MockGeneratePasswordUseCase();
    mockEstimateStrengthUseCase = MockEstimatePasswordStrengthUseCase();
    mockGetSettingsUseCase = MockGetPasswordGenerationSettingsUseCase();
    mockSavePasswordUseCase = MockSavePasswordUseCase();

    bloc = AddEditPasswordBloc(
      mockGeneratePasswordUseCase,
      mockEstimateStrengthUseCase,
      mockGetSettingsUseCase,
      mockSavePasswordUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('$AddEditPasswordBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.status, AddEditStatus.initial);
      expect(bloc.state.strength, 0.0);
      expect(bloc.state.generatedPassword, '');
    });

    group('$PasswordChanged', () {
      test('updates strength when password changes', () async {
        when(() => mockEstimateStrengthUseCase('test123')).thenReturn(0.5);

        bloc.add(const PasswordChanged('test123'));
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.strength, 0.5);
      });

      test('resets status to initial when password changes manually', () async {
        // This is the bug fix test case:
        // When user types manually after generating, status should reset to initial
        // so that listener doesn't override user's input

        when(() => mockEstimateStrengthUseCase(any())).thenReturn(0.75);
        when(
          () => mockGetSettingsUseCase(),
        ).thenReturn(const Success(PasswordGenerationSettings()));
        when(
          () => mockGeneratePasswordUseCase(
            length: any(named: 'length'),
            useSpecialChars: any(named: 'useSpecialChars'),
            useNumbers: any(named: 'useNumbers'),
            useUppercase: any(named: 'useUppercase'),
            useLowercase: any(named: 'useLowercase'),
            excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
          ),
        ).thenReturn('GeneratedPass123!');

        // First, generate a password
        bloc.add(GenerateStrongPassword());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.status, AddEditStatus.generated);
        expect(bloc.state.generatedPassword, 'GeneratedPass123!');

        // Now, user types manually - status should reset to initial
        bloc.add(const PasswordChanged('MyManualPassword'));
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.status, AddEditStatus.initial);
        expect(bloc.state.strength, 0.75);
      });

      test('strength updates correctly for different passwords', () async {
        when(() => mockEstimateStrengthUseCase('weak')).thenReturn(0.1);
        when(
          () => mockEstimateStrengthUseCase('StrongPassword123!'),
        ).thenReturn(0.95);

        // Test weak password
        bloc.add(const PasswordChanged('weak'));
        await Future.delayed(const Duration(milliseconds: 50));
        expect(bloc.state.strength, 0.1);

        // Test strong password
        bloc.add(const PasswordChanged('StrongPassword123!'));
        await Future.delayed(const Duration(milliseconds: 50));
        expect(bloc.state.strength, 0.95);
      });
    });

    group('$GenerateStrongPassword', () {
      test('generates password and updates state', () async {
        when(
          () => mockGetSettingsUseCase(),
        ).thenReturn(const Success(PasswordGenerationSettings()));
        when(
          () => mockGeneratePasswordUseCase(
            length: any(named: 'length'),
            useSpecialChars: any(named: 'useSpecialChars'),
            useNumbers: any(named: 'useNumbers'),
            useUppercase: any(named: 'useUppercase'),
            useLowercase: any(named: 'useLowercase'),
            excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
          ),
        ).thenReturn('SecurePassword123!');
        when(
          () => mockEstimateStrengthUseCase('SecurePassword123!'),
        ).thenReturn(0.9);

        bloc.add(GenerateStrongPassword());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.status, AddEditStatus.generated);
        expect(bloc.state.generatedPassword, 'SecurePassword123!');
        expect(bloc.state.strength, 0.9);
      });

      test('uses default settings when no saved settings', () async {
        when(
          () => mockGetSettingsUseCase(),
        ).thenReturn(const Success(PasswordGenerationSettings()));
        when(
          () => mockGeneratePasswordUseCase(
            length: 16, // default
            useSpecialChars: true, // default
            useNumbers: true, // default
            useUppercase: true, // default
            useLowercase: true, // default
            excludeAmbiguousChars: false, // default
          ),
        ).thenReturn('DefaultPassword!');
        when(
          () => mockEstimateStrengthUseCase('DefaultPassword!'),
        ).thenReturn(0.8);

        bloc.add(GenerateStrongPassword());
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockGeneratePasswordUseCase(
            length: 16,
            useSpecialChars: true,
            useNumbers: true,
            useUppercase: true,
            useLowercase: true,
            excludeAmbiguousChars: false,
          ),
        ).called(1);
      });
    });
  });
}
