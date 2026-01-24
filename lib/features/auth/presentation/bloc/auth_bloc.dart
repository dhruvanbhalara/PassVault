import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_event.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_state.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';

export 'auth_event.dart';
export 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateUseCase _authenticateUseCase;
  final AuthRepository _authRepository;
  final GetBiometricsEnabledUseCase _getBiometricsEnabledUseCase;

  AuthBloc(
    this._authenticateUseCase,
    this._authRepository,
    this._getBiometricsEnabledUseCase,
  ) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = _getBiometricsEnabledUseCase();
    final useBiometrics = result.fold((failure) => false, (enabled) => enabled);

    if (!useBiometrics) {
      emit(AuthAuthenticated());
      return;
    }

    final bioResult = await _authRepository.isBiometricAvailable();
    bioResult.fold(
      (failure) => emit(const AuthUnauthenticated(error: AuthError.authFailed)),
      (available) {
        if (!available) {
          emit(
            const AuthUnauthenticated(error: AuthError.biometricsNotAvailable),
          );
        } else {
          emit(AuthInitial());
        }
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authenticateUseCase();
    result.fold(
      (failure) => emit(const AuthUnauthenticated(error: AuthError.authFailed)),
      (success) {
        if (success) {
          emit(AuthAuthenticated());
        } else {
          emit(const AuthUnauthenticated(error: AuthError.authFailed));
        }
      },
    );
  }
}
