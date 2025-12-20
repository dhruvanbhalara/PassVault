import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthenticateUseCase extends Mock implements AuthenticateUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late AuthBloc bloc;
  late MockAuthenticateUseCase mockAuthenticateUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockAuthenticateUseCase = MockAuthenticateUseCase();
    mockAuthRepository = MockAuthRepository();
    mockDatabaseService = MockDatabaseService();

    bloc = AuthBloc(
      mockAuthenticateUseCase,
      mockAuthRepository,
      mockDatabaseService,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(bloc.state, isA<AuthInitial>());
    });

    group('AuthCheckRequested', () {
      test('emits AuthAuthenticated when biometrics disabled', () async {
        when(
          () => mockDatabaseService.read(
            any(),
            any(),
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenReturn(false);

        final states = <AuthState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(AuthCheckRequested());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.last, isA<AuthAuthenticated>());
      });

      test(
        'emits AuthUnauthenticated when biometrics enabled but unavailable',
        () async {
          when(
            () => mockDatabaseService.read(
              any(),
              any(),
              defaultValue: any(named: 'defaultValue'),
            ),
          ).thenReturn(true);
          when(
            () => mockAuthRepository.isBiometricAvailable(),
          ).thenAnswer((_) async => false);

          final states = <AuthState>[];
          final subscription = bloc.stream.listen(states.add);

          bloc.add(AuthCheckRequested());

          await Future.delayed(const Duration(milliseconds: 100));
          await subscription.cancel();

          expect(states.last, isA<AuthUnauthenticated>());
          expect(
            (states.last as AuthUnauthenticated).error,
            AuthError.biometricsNotAvailable,
          );
        },
      );

      test('emits AuthInitial when biometrics enabled and available', () async {
        when(
          () => mockDatabaseService.read(
            any(),
            any(),
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenReturn(true);
        when(
          () => mockAuthRepository.isBiometricAvailable(),
        ).thenAnswer((_) async => true);

        final states = <AuthState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(AuthCheckRequested());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.last, isA<AuthInitial>());
      });
    });

    group('AuthLoginRequested', () {
      test('emits AuthLoading then AuthAuthenticated on success', () async {
        when(() => mockAuthenticateUseCase()).thenAnswer((_) async => true);

        final states = <AuthState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(AuthLoginRequested());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<AuthAuthenticated>());
      });

      test('emits AuthLoading then AuthUnauthenticated on failure', () async {
        when(() => mockAuthenticateUseCase()).thenAnswer((_) async => false);

        final states = <AuthState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(AuthLoginRequested());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<AuthUnauthenticated>());
        expect((states[1] as AuthUnauthenticated).error, AuthError.authFailed);
      });
    });
  });
}
