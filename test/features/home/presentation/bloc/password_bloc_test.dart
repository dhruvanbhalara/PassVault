import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

class MockGetPasswordsUseCase extends Mock implements GetPasswordsUseCase {}

class MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

class MockDeletePasswordUseCase extends Mock implements DeletePasswordUseCase {}

void main() {
  late PasswordBloc bloc;
  late MockGetPasswordsUseCase mockGetPasswordsUseCase;
  late MockSavePasswordUseCase mockSavePasswordUseCase;
  late MockDeletePasswordUseCase mockDeletePasswordUseCase;

  final testPassword = PasswordEntry(
    id: 'test-id-1',
    appName: 'Test App',
    username: 'testuser',
    password: 'testpassword123',
    lastUpdated: DateTime(2024, 1, 1),
  );

  final testPassword2 = PasswordEntry(
    id: 'test-id-2',
    appName: 'Another App',
    username: 'user2',
    password: 'password456',
    lastUpdated: DateTime(2024, 1, 2),
  );

  setUp(() {
    mockGetPasswordsUseCase = MockGetPasswordsUseCase();
    mockSavePasswordUseCase = MockSavePasswordUseCase();
    mockDeletePasswordUseCase = MockDeletePasswordUseCase();

    bloc = PasswordBloc(
      mockGetPasswordsUseCase,
      mockSavePasswordUseCase,
      mockDeletePasswordUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(testPassword);
  });

  tearDown(() {
    bloc.close();
  });

  group('PasswordBloc', () {
    test('initial state is PasswordInitial', () {
      expect(bloc.state, isA<PasswordInitial>());
    });

    group('LoadPasswords', () {
      test('emits PasswordLoading then PasswordLoaded on success', () async {
        when(
          () => mockGetPasswordsUseCase(),
        ).thenAnswer((_) async => [testPassword, testPassword2]);

        final states = <PasswordState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(LoadPasswords());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 2);
        expect(states[0], isA<PasswordLoading>());
        expect(states[1], isA<PasswordLoaded>());

        final loaded = states[1] as PasswordLoaded;
        expect(loaded.passwords.length, 2);
        expect(loaded.passwords[0].appName, 'Test App');
      });

      test('emits PasswordLoading then PasswordError on failure', () async {
        when(
          () => mockGetPasswordsUseCase(),
        ).thenThrow(Exception('Failed to load'));

        final states = <PasswordState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(LoadPasswords());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 2);
        expect(states[0], isA<PasswordLoading>());
        expect(states[1], isA<PasswordError>());
      });

      test('calls getPasswordsUseCase', () async {
        when(() => mockGetPasswordsUseCase()).thenAnswer((_) async => []);

        bloc.add(LoadPasswords());
        await Future.delayed(const Duration(milliseconds: 100));

        verify(() => mockGetPasswordsUseCase()).called(1);
      });
    });

    group('AddPassword', () {
      test('calls savePasswordUseCase and reloads', () async {
        when(() => mockSavePasswordUseCase(any())).thenAnswer((_) async {});
        when(
          () => mockGetPasswordsUseCase(),
        ).thenAnswer((_) async => [testPassword]);

        bloc.add(AddPassword(testPassword));
        await Future.delayed(const Duration(milliseconds: 100));

        verify(() => mockSavePasswordUseCase(testPassword)).called(1);
        verify(() => mockGetPasswordsUseCase()).called(1);
      });
    });

    group('UpdatePassword', () {
      test('calls savePasswordUseCase with updated entry', () async {
        when(() => mockSavePasswordUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetPasswordsUseCase()).thenAnswer((_) async => []);

        bloc.add(UpdatePassword(testPassword));
        await Future.delayed(const Duration(milliseconds: 100));

        verify(() => mockSavePasswordUseCase(testPassword)).called(1);
      });
    });

    group('DeletePassword', () {
      test('calls deletePasswordUseCase and reloads', () async {
        when(() => mockDeletePasswordUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetPasswordsUseCase()).thenAnswer((_) async => []);

        bloc.add(const DeletePassword('test-id-1'));
        await Future.delayed(const Duration(milliseconds: 100));

        verify(() => mockDeletePasswordUseCase('test-id-1')).called(1);
        verify(() => mockGetPasswordsUseCase()).called(1);
      });
    });
  });
}
