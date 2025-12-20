import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
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
  final DatabaseService _dbService;

  AuthBloc(this._authenticateUseCase, this._authRepository, this._dbService)
    : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final useBiometrics = _dbService.read(
      'settings',
      'use_biometrics',
      defaultValue: false,
    );

    if (!useBiometrics) {
      emit(AuthAuthenticated());
      return;
    }

    final available = await _authRepository.isBiometricAvailable();
    if (!available) {
      emit(const AuthUnauthenticated(error: AuthError.biometricsNotAvailable));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final success = await _authenticateUseCase();
    if (success) {
      emit(AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated(error: AuthError.authFailed));
    }
  }
}
