import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

// States
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

enum AuthError { none, biometricsNotAvailable, authFailed }

class AuthUnauthenticated extends AuthState {
  final AuthError error;
  const AuthUnauthenticated({this.error = AuthError.none});

  @override
  List<Object> get props => [error];
}

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
