import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/observers/go_router_observer.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/auth/presentation/auth_screen.dart';
import 'package:passvault/features/home/presentation/home_screen.dart';
import 'package:passvault/features/onboarding/presentation/intro_screen.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/add_edit_password_screen.dart';
import 'package:passvault/features/password_manager/presentation/duplicate_resolution_screen.dart';
import 'package:passvault/features/settings/presentation/settings_screen.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  observers: kDebugMode ? [GoRouterObserver()] : [],
  initialLocation: AppRoutes.auth,
  redirect: (context, state) {
    final databaseService = getIt<DatabaseService>();
    final onboardingComplete = databaseService.read(
      'settings',
      'onboarding_complete',
      defaultValue: false,
    );

    if (!onboardingComplete && state.matchedLocation != AppRoutes.intro) {
      return AppRoutes.intro;
    }

    if (onboardingComplete && state.matchedLocation == AppRoutes.intro) {
      return AppRoutes.auth;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.intro,
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.addPassword,
      builder: (context, state) => const AddEditPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.editPassword,
      builder: (context, state) =>
          AddEditPasswordScreen(entry: state.extra as PasswordEntry),
    ),
    GoRoute(
      path: AppRoutes.resolveDuplicates,
      builder: (context, state) => DuplicateResolutionScreen(
        duplicates: state.extra as List<DuplicatePasswordEntry>,
      ),
    ),
  ],
);
