import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateUseCase _authenticateUseCase;
  final AuthRepository _authRepository;
  final GetBiometricsEnabledUseCase _getBiometricsEnabledUseCase;

  AuthBloc(
    this._authenticateUseCase,
    this._authRepository,
    this._getBiometricsEnabledUseCase,
  ) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Checking auth requirements', tag: 'AuthBloc');
    final result = _getBiometricsEnabledUseCase();
    final useBiometrics = result.fold((failure) => false, (enabled) => enabled);

    if (!useBiometrics) {
      AppLogger.info('Biometrics disabled by user, skipping', tag: 'AuthBloc');
      emit(const AuthAuthenticated());
      return;
    }

    final bioResult = await _authRepository.isBiometricAvailable();
    bioResult.fold(
      (failure) {
        AppLogger.error(
          'Biometric availability check failed',
          error: failure,
          tag: 'AuthBloc',
        );
        emit(const AuthUnauthenticated(error: AuthError.authFailed));
      },
      (available) {
        if (!available) {
          AppLogger.warning(
            'Biometrics enabled but not available on device',
            tag: 'AuthBloc',
          );
          emit(
            const AuthUnauthenticated(error: AuthError.biometricsNotAvailable),
          );
        } else {
          AppLogger.info(
            'Biometrics available, auto-triggering login',
            tag: 'AuthBloc',
          );
          add(const AuthLoginRequested());
          emit(const AuthInitial());
        }
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Requesting biometric login', tag: 'AuthBloc');
    emit(const AuthLoading());
    final result = await _authenticateUseCase();
    result.fold(
      (failure) {
        AppLogger.error(
          'Authentication process failed',
          error: failure,
          tag: 'AuthBloc',
        );
        emit(const AuthUnauthenticated(error: AuthError.authFailed));
      },
      (success) {
        if (success) {
          AppLogger.info('Authentication successful', tag: 'AuthBloc');
          emit(const AuthAuthenticated());
        } else {
          AppLogger.warning(
            'Authentication cancelled or failed by user',
            tag: 'AuthBloc',
          );
          emit(const AuthUnauthenticated(error: AuthError.authFailed));
        }
      },
    );
  }
}
