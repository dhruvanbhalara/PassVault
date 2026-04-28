import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/config/routes/router_transitions.dart';
import 'package:passvault/core/design_system/components/error/app_error_page.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/observers/go_router_observer.dart';
import 'package:passvault/features/auth/presentation/auth_screen.dart';
import 'package:passvault/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';
import 'package:passvault/features/generator/presentation/generator_screen.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/home/presentation/home_screen.dart';
import 'package:passvault/features/home/presentation/screens/grouped_password_details_screen.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:passvault/features/onboarding/presentation/intro_screen.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/add_edit_password_screen.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/duplicate_resolution_screen.dart';
import 'package:passvault/features/password_manager/presentation/export_vault_screen.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor_screen.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_screen.dart';
import 'package:passvault/features/settings/presentation/settings_screen.dart';
import 'package:passvault/features/shell/presentation/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@lazySingleton
class AppRouter {
  final GetOnboardingCompleteUseCase _getOnboardingCompleteUseCase;
  final GetBiometricsEnabledUseCase _getBiometricsEnabledUseCase;

  AppRouter(
    this._getOnboardingCompleteUseCase,
    this._getBiometricsEnabledUseCase,
  );

  late final GoRouter config = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    observers: kDebugMode ? [GoRouterObserver()] : [],
    errorBuilder: (context, state) => AppErrorPage(error: state.error),
    initialLocation: AppRoutes.auth,
    redirect: (context, state) {
      final onboardingComplete = _getOnboardingCompleteUseCase().fold(
        (failure) => false,
        (complete) => complete,
      );
      final useBiometrics = _getBiometricsEnabledUseCase().fold(
        (failure) => false,
        (enabled) => enabled,
      );

      final isOnboardingRoute = state.matchedLocation == AppRoutes.intro;
      final isAuthRoute = state.matchedLocation == AppRoutes.auth;

      if (!onboardingComplete && !isOnboardingRoute) {
        return AppRoutes.intro;
      }

      if (onboardingComplete && isOnboardingRoute) {
        return useBiometrics ? AppRoutes.auth : AppRoutes.home;
      }

      if (onboardingComplete && !useBiometrics && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) =>
                getIt<OnboardingBloc>()..add(const OnboardingStarted()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.intro,
            pageBuilder: (context, state) =>
                buildSlideTransition(const IntroScreen(), state),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthCheckRequested()),
          child: const AuthScreen(),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return BlocProvider.value(
                    value: getIt<PasswordBloc>()..add(const LoadPasswords()),
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.home,
                    builder: (context, state) => const HomeScreen(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.addPasswordRoute,
                        parentNavigatorKey: _rootNavigatorKey,
                        pageBuilder: (context, state) => buildSlideTransition(
                          const AddEditPasswordScreen(),
                          state,
                        ),
                      ),
                      GoRoute(
                        path: AppRoutes.editPasswordRoute,
                        parentNavigatorKey: _rootNavigatorKey,
                        pageBuilder: (context, state) => buildSlideTransition(
                          AddEditPasswordScreen(
                            id: (state.extra as PasswordEntry?)?.id,
                          ),
                          state,
                        ),
                      ),
                      GoRoute(
                        path: AppRoutes.groupedPasswordDetailsSubRoute,
                        pageBuilder: (context, state) {
                          final groupKey = Uri.decodeComponent(
                            state.pathParameters[AppRoutes
                                    .groupedPasswordKeyParam] ??
                                '',
                          );
                          return buildSlideTransition(
                            GroupedPasswordDetailsScreen(groupKey: groupKey),
                            state,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => getIt<GeneratorBloc>()),
                      BlocProvider.value(value: getIt<SettingsBloc>()),
                    ],
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.generator,
                    builder: (context, state) => const GeneratorScreen(),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            getIt<SettingsBloc>()..add(const LoadSettings()),
                      ),
                      BlocProvider(
                        create: (context) => getIt<ImportExportBloc>(),
                      ),
                    ],
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.settings,
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.resolveDuplicates,
        builder: (context, state) => BlocProvider.value(
          value: getIt<ImportExportBloc>(),
          child: const DuplicateResolutionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.exportVault,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => buildSlideTransition(
          BlocProvider.value(
            value: getIt<ImportExportBloc>(),
            child: const ExportVaultScreen(),
          ),
          state,
        ),
      ),
      GoRoute(
        path: AppRoutes.strategy,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => buildSlideTransition(
          BlocProvider.value(
            value: getIt<SettingsBloc>(),
            child: const StrategyScreen(),
          ),
          state,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.strategyEditorRoute,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final strategyId =
                  (state.extra as Map<String, String>)['strategyId'];
              return buildSlideTransition(
                BlocProvider.value(
                  value: getIt<SettingsBloc>(),
                  child: StrategyEditorScreen(strategyId: strategyId),
                ),
                state,
              );
            },
          ),
        ],
      ),
    ],
  );
}
