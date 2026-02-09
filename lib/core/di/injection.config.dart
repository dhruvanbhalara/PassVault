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
import 'package:local_auth/local_auth.dart' as _i152;

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
import '../../features/password_manager/data/exporters/csv_exporter.dart'
    as _i288;
import '../../features/password_manager/data/repositories/password_repository_impl.dart'
    as _i826;
import '../../features/password_manager/domain/repositories/password_repository.dart'
    as _i580;
import '../../features/password_manager/domain/usecases/clear_all_passwords_usecase.dart'
    as _i766;
import '../../features/password_manager/domain/usecases/estimate_password_strength_usecase.dart'
    as _i371;
import '../../features/password_manager/domain/usecases/export_passwords_usecase.dart'
    as _i145;
import '../../features/password_manager/domain/usecases/generate_password_usecase.dart'
    as _i16;
import '../../features/password_manager/domain/usecases/import_passwords_usecase.dart'
    as _i823;
import '../../features/password_manager/domain/usecases/password_usecases.dart'
    as _i969;
import '../../features/password_manager/domain/usecases/resolve_duplicates_usecase.dart'
    as _i649;
import '../../features/password_manager/domain/usecases/save_bulk_passwords_usecase.dart'
    as _i537;
import '../../features/password_manager/presentation/bloc/add_edit_password_bloc.dart'
    as _i683;
import '../../features/password_manager/presentation/bloc/import_export_bloc.dart'
    as _i404;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/biometrics_usecases.dart'
    as _i360;
import '../../features/settings/domain/usecases/get_theme_usecase.dart' as _i6;
import '../../features/settings/domain/usecases/onboarding_usecases.dart'
    as _i830;
import '../../features/settings/domain/usecases/password_settings_usecases.dart'
    as _i739;
import '../../features/settings/domain/usecases/set_theme_usecase.dart'
    as _i986;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;
import '../../features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart'
    as _i309;
import '../../features/settings/presentation/bloc/theme/theme_bloc.dart'
    as _i242;
import '../services/biometric_service.dart' as _i374;
import '../services/crypto_service.dart' as _i1024;
import '../services/data_service.dart' as _i636;
import '../services/database_service.dart' as _i665;
import '../services/encrypted_storage_service.dart' as _i311;
import '../services/file_picker_service.dart' as _i108;
import '../services/file_picker_service_impl.dart' as _i988;
import '../services/file_service.dart' as _i367;
import '../services/file_service_impl.dart' as _i276;
import '../services/storage_service.dart' as _i306;

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
    gh.lazySingleton<_i1024.CryptoService>(() => _i1024.CryptoService());
    gh.lazySingleton<_i152.LocalAuthentication>(
      () => storageModule.localAuthentication,
    );
    gh.lazySingleton<_i288.CsvExporter>(() => _i288.CsvExporter());
    gh.lazySingleton<_i371.EstimatePasswordStrengthUseCase>(
      () => _i371.EstimatePasswordStrengthUseCase(),
    );
    gh.lazySingleton<_i16.GeneratePasswordUseCase>(
      () => _i16.GeneratePasswordUseCase(),
    );
    gh.lazySingleton<_i367.FileService>(() => _i276.FileServiceImpl());
    gh.lazySingleton<_i108.IFilePickerService>(
      () => _i988.FilePickerServiceImpl(),
    );
    gh.lazySingleton<_i311.EncryptedStorageService>(
      () => _i311.EncryptedStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    await gh.singletonAsync<_i919.Box<dynamic>>(
      () => storageModule.openPasswordBox(gh<_i311.EncryptedStorageService>()),
      instanceName: 'passwordBox',
      preResolve: true,
    );
    gh.lazySingleton<_i374.BiometricService>(
      () => _i374.BiometricService(auth: gh<_i152.LocalAuthentication>()),
    );
    gh.lazySingleton<_i636.DataService>(
      () => _i636.DataService(gh<_i1024.CryptoService>()),
    );
    gh.factory<_i309.StrategyPreviewBloc>(
      () => _i309.StrategyPreviewBloc(gh<_i16.GeneratePasswordUseCase>()),
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
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i665.DatabaseService>()),
    );
    gh.lazySingleton<_i580.PasswordRepository>(
      () => _i826.PasswordRepositoryImpl(
        gh<_i385.PasswordLocalDataSource>(),
        gh<_i288.CsvExporter>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i145.ExportPasswordsUseCase>(
      () => _i145.ExportPasswordsUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.lazySingleton<_i823.ImportPasswordsUseCase>(
      () => _i823.ImportPasswordsUseCase(gh<_i580.PasswordRepository>()),
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
    gh.lazySingleton<_i649.ResolveDuplicatesUseCase>(
      () => _i649.ResolveDuplicatesUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.factory<_i766.ClearAllPasswordsUseCase>(
      () => _i766.ClearAllPasswordsUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.factory<_i537.SaveBulkPasswordsUseCase>(
      () => _i537.SaveBulkPasswordsUseCase(gh<_i580.PasswordRepository>()),
    );
    gh.factory<_i585.SettingsBloc>(
      () => _i585.SettingsBloc(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i360.GetBiometricsEnabledUseCase>(
      () => _i360.GetBiometricsEnabledUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i360.SetBiometricsEnabledUseCase>(
      () => _i360.SetBiometricsEnabledUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i6.GetThemeUseCase>(
      () => _i6.GetThemeUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i830.GetOnboardingCompleteUseCase>(
      () => _i830.GetOnboardingCompleteUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i830.SetOnboardingCompleteUseCase>(
      () => _i830.SetOnboardingCompleteUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i739.GetPasswordGenerationSettingsUseCase>(
      () => _i739.GetPasswordGenerationSettingsUseCase(
        gh<_i674.SettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i739.SavePasswordGenerationSettingsUseCase>(
      () => _i739.SavePasswordGenerationSettingsUseCase(
        gh<_i674.SettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i986.SetThemeUseCase>(
      () => _i986.SetThemeUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i242.ThemeBloc>(
      () => _i242.ThemeBloc(
        gh<_i6.GetThemeUseCase>(),
        gh<_i986.SetThemeUseCase>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i1045.AuthenticateUseCase>(),
        gh<_i787.AuthRepository>(),
        gh<_i360.GetBiometricsEnabledUseCase>(),
      ),
    );
    gh.factory<_i404.ImportExportBloc>(
      () => _i404.ImportExportBloc(
        gh<_i823.ImportPasswordsUseCase>(),
        gh<_i649.ResolveDuplicatesUseCase>(),
        gh<_i766.ClearAllPasswordsUseCase>(),
        gh<_i580.PasswordRepository>(),
        gh<_i636.DataService>(),
        gh<_i367.FileService>(),
        gh<_i108.IFilePickerService>(),
      ),
    );
    gh.factory<_i792.OnboardingBloc>(
      () => _i792.OnboardingBloc(gh<_i830.SetOnboardingCompleteUseCase>()),
    );
    gh.lazySingleton<_i552.PasswordBloc>(
      () => _i552.PasswordBloc(
        gh<_i969.GetPasswordsUseCase>(),
        gh<_i969.SavePasswordUseCase>(),
        gh<_i969.DeletePasswordUseCase>(),
        gh<_i580.PasswordRepository>(),
      ),
    );
    gh.factory<_i683.AddEditPasswordBloc>(
      () => _i683.AddEditPasswordBloc(
        gh<_i16.GeneratePasswordUseCase>(),
        gh<_i371.EstimatePasswordStrengthUseCase>(),
        gh<_i739.GetPasswordGenerationSettingsUseCase>(),
        gh<_i969.SavePasswordUseCase>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i306.StorageModule {}
