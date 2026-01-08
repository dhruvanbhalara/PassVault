// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce_flutter/hive_flutter.dart' as _i919;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/authenticate_usecase.dart'
    as _i1045;
import '../../features/auth/domain/usecases/check_biometrics_usecase.dart'
    as _i458;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/home/presentation/bloc/password_bloc.dart' as _i552;
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i792;
import '../../features/password_manager/data/datasources/password_local_data_source.dart'
    as _i385;
import '../../features/password_manager/data/repositories/password_repository_impl.dart'
    as _i826;
import '../../features/password_manager/domain/repositories/password_repository.dart'
    as _i580;
import '../../features/password_manager/domain/usecases/estimate_password_strength_usecase.dart'
    as _i371;
import '../../features/password_manager/domain/usecases/generate_password_usecase.dart'
    as _i16;
import '../../features/password_manager/domain/usecases/password_usecases.dart'
    as _i969;
import '../../features/password_manager/presentation/bloc/add_edit_password_bloc.dart'
    as _i683;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;
import '../services/biometric_service.dart' as _i374;
import '../services/crypto_service.dart' as _i1024;
import '../services/data_service.dart' as _i636;
import '../services/database_service.dart' as _i665;
import '../services/encrypted_storage_service.dart' as _i311;
import '../services/storage_service.dart' as _i306;
import '../theme/bloc/theme_cubit.dart' as _i735;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    await gh.singletonAsync<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
      preResolve: true,
    );
    gh.lazySingleton<_i374.BiometricService>(() => _i374.BiometricService());
    gh.lazySingleton<_i1024.CryptoService>(() => _i1024.CryptoService());
    gh.lazySingleton<_i371.EstimatePasswordStrengthUseCase>(
      () => _i371.EstimatePasswordStrengthUseCase(),
    );
    gh.lazySingleton<_i16.GeneratePasswordUseCase>(
      () => _i16.GeneratePasswordUseCase(),
    );
    gh.lazySingleton<_i311.EncryptedStorageService>(
      () => _i311.EncryptedStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    await gh.singletonAsync<_i919.Box<dynamic>>(
      () => storageModule.openPasswordBox(gh<_i311.EncryptedStorageService>()),
      instanceName: 'passwordBox',
      preResolve: true,
    );
    gh.lazySingleton<_i636.DataService>(
      () => _i636.DataService(gh<_i1024.CryptoService>()),
    );
    await gh.singletonAsync<_i919.Box<dynamic>>(
      () => storageModule.openSettingsBox(
        gh<_i311.EncryptedStorageService>(),
        gh<_i919.Box<dynamic>>(instanceName: 'passwordBox'),
      ),
      instanceName: 'settingsBox',
      preResolve: true,
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i374.BiometricService>()),
    );
    gh.lazySingleton<_i385.PasswordLocalDataSource>(
      () => _i385.PasswordLocalDataSourceImpl(
        gh<_i919.Box<dynamic>>(instanceName: 'passwordBox'),
      ),
    );
    gh.lazySingleton<_i665.DatabaseService>(
      () => _i665.DatabaseService(
        gh<_i919.Box<dynamic>>(instanceName: 'settingsBox'),
      ),
    );
    gh.lazySingleton<_i1045.AuthenticateUseCase>(
      () => _i1045.AuthenticateUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i458.CheckBiometricsUseCase>(
      () => _i458.CheckBiometricsUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i1045.AuthenticateUseCase>(),
        gh<_i787.AuthRepository>(),
        gh<_i665.DatabaseService>(),
      ),
    );
    gh.factory<_i683.AddEditPasswordBloc>(
      () => _i683.AddEditPasswordBloc(
        gh<_i16.GeneratePasswordUseCase>(),
        gh<_i371.EstimatePasswordStrengthUseCase>(),
        gh<_i665.DatabaseService>(),
      ),
    );
    gh.lazySingleton<_i580.PasswordRepository>(
      () => _i826.PasswordRepositoryImpl(gh<_i385.PasswordLocalDataSource>()),
    );
    gh.factory<_i792.OnboardingBloc>(
      () => _i792.OnboardingBloc(gh<_i665.DatabaseService>()),
    );
    gh.lazySingleton<_i735.ThemeCubit>(
      () => _i735.ThemeCubit(gh<_i665.DatabaseService>()),
    );
    gh.factory<_i585.SettingsBloc>(
      () => _i585.SettingsBloc(
        gh<_i665.DatabaseService>(),
        gh<_i636.DataService>(),
        gh<_i580.PasswordRepository>(),
      ),
    );
    gh.lazySingleton<_i969.GetPasswordsUseCase>(
      () => _i969.GetPasswordsUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.lazySingleton<_i969.SavePasswordUseCase>(
      () => _i969.SavePasswordUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.lazySingleton<_i969.DeletePasswordUseCase>(
      () => _i969.DeletePasswordUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.lazySingleton<_i552.PasswordBloc>(
      () => _i552.PasswordBloc(
        gh<_i969.GetPasswordsUseCase>(),
        gh<_i969.SavePasswordUseCase>(),
        gh<_i969.DeletePasswordUseCase>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i306.StorageModule {}
