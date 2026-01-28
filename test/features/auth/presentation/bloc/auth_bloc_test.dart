import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';

class MockAuthenticateUseCase extends Mock implements AuthenticateUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockGetBiometricsEnabledUseCase extends Mock
    implements GetBiometricsEnabledUseCase {}

void main() {
  late AuthBloc bloc;
  late MockAuthenticateUseCase mockAuthenticateUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockGetBiometricsEnabledUseCase mockGetBiometricsEnabledUseCase;

  setUp(() {
    mockAuthenticateUseCase = MockAuthenticateUseCase();
    mockAuthRepository = MockAuthRepository();
    mockGetBiometricsEnabledUseCase = MockGetBiometricsEnabledUseCase();

    bloc = AuthBloc(
      mockAuthenticateUseCase,
      mockAuthRepository,
      mockGetBiometricsEnabledUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('$AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(bloc.state, isA<AuthInitial>());
    });

    group('$AuthCheckRequested', () {
      test('emits AuthAuthenticated when biometrics disabled', () async {
        when(
          () => mockGetBiometricsEnabledUseCase(),
        ).thenReturn(const Success(false));

        final states = <AuthState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(AuthCheckRequested());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.last, isA<AuthAuthenticated>());
      });

      test(
        'emits AuthAuthenticated when available but user disabled',
        () async {
          when(
            () => mockGetBiometricsEnabledUseCase(),
          ).thenReturn(const Success(false));

          bloc.add(AuthCheckRequested());
          await Future.delayed(const Duration(milliseconds: 100));

          expect(bloc.state, isA<AuthAuthenticated>());
        },
      );

      test(
        'checks biometric availability and triggers login when enabled',
        () async {
          when(
            () => mockGetBiometricsEnabledUseCase(),
          ).thenReturn(const Success(true));
          when(
            () => mockAuthRepository.isBiometricAvailable(),
          ).thenAnswer((_) async => const Success(true));
          when(
            () => mockAuthenticateUseCase(),
          ).thenAnswer((_) async => const Success(true));

          bloc.add(AuthCheckRequested());
          await Future.delayed(const Duration(milliseconds: 100));

          verify(() => mockAuthRepository.isBiometricAvailable()).called(1);
          verify(() => mockAuthenticateUseCase()).called(1);
          expect(bloc.state, isA<AuthAuthenticated>());
        },
      );

      test(
        'emits AuthUnauthenticated when biometrics enabled but unavailable',
        () async {
          when(
            () => mockGetBiometricsEnabledUseCase(),
          ).thenReturn(const Success(true));
          when(
            () => mockAuthRepository.isBiometricAvailable(),
          ).thenAnswer((_) async => const Success(false));

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
      test(
        'emits AuthInitial and triggers login when biometrics enabled and available',
        () async {
          when(
            () => mockGetBiometricsEnabledUseCase(),
          ).thenReturn(const Success(true));
          when(
            () => mockAuthRepository.isBiometricAvailable(),
          ).thenAnswer((_) async => const Success(true));
          when(
            () => mockAuthenticateUseCase(),
          ).thenAnswer((_) async => const Success(true));

          final states = <AuthState>[];
          final subscription = bloc.stream.listen(states.add);

          bloc.add(AuthCheckRequested());

          await Future.delayed(const Duration(milliseconds: 100));
          await subscription.cancel();

          // 1. AuthInitial (from AuthCheckRequested)
          // 2. AuthLoading (from AuthLoginRequested)
          // 3. AuthAuthenticated (from AuthLoginRequested success)
          expect(states, hasLength(3));
          expect(states[0], isA<AuthInitial>());
          expect(states[1], isA<AuthLoading>());
          expect(states[2], isA<AuthAuthenticated>());
        },
      );
    });

    group('$AuthLoginRequested', () {
      test('emits AuthLoading then AuthAuthenticated on success', () async {
        when(
          () => mockAuthenticateUseCase(),
        ).thenAnswer((_) async => const Success(true));

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
        when(
          () => mockAuthenticateUseCase(),
        ).thenAnswer((_) async => const Success(false));

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
