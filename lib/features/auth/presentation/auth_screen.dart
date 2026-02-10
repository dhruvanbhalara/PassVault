import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';

/// Screen responsible for biometric and local authentication.
///
/// Acts as the gatekeeper for the application, ensuring the user
/// is authenticated before accessing the vault.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: const AuthView(),
    );
  }
}

/// The stateful UI for the authentication gate.
class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthStateChanges,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: theme.vaultGradient),
          child: const SafeArea(child: Center(child: _AuthContent())),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    final theme = context.theme;
    if (state is AuthAuthenticated) {
      context.go(AppRoutes.home);
    } else if (state is AuthUnauthenticated) {
      final l10n = context.l10n;
      String? message;
      switch (state.error) {
        case AuthError.authFailed:
          message = l10n.authFailed;
        case AuthError.biometricsNotAvailable:
          message = l10n.biometricsNotAvailable;
        case AuthError.none:
          message = null;
      }

      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.error,
            behavior: SnackBarBehavior.floating,
            duration: AppDuration.normal,
          ),
        );
      }
    }
  }
}

class _AuthContent extends StatelessWidget {
  const _AuthContent();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return AppLoader(
            key: const Key('auth_loading'),
            color: theme.onVaultGradient,
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _AuthAnimation(),
            SizedBox(
              height: context.responsive(AppSpacing.xl, tablet: AppSpacing.xxl),
            ),
            const _AuthHeader(),
            SizedBox(
              height: context.responsive(
                AppSpacing.xxl,
                tablet: AppSpacing.xxxl,
              ),
            ),
            const _AuthButton(),
          ],
        );
      },
    );
  }
}

class _AuthAnimation extends StatelessWidget {
  const _AuthAnimation();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: context.responsive(
          AppDimensions.authAnimationHeight,
          tablet: AppDimensions.authAnimationHeightTablet,
        ),
        child: Lottie.asset(
          'assets/animations/fingerprint.json',
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      children: [
        Text(
          context.l10n.appName,
          key: const Key('auth_title'),
          style: context.typography.headlineLarge?.copyWith(
            color: theme.onVaultGradient,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Text(
          context.l10n.locked,
          key: const Key('auth_locked_text'),
          style: context.typography.bodyMedium?.copyWith(
            color: theme.onVaultGradient.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(AppSpacing.xxl, tablet: AppSpacing.xxxl),
      ),
      child: SizedBox(
        width: context.responsive(
          double.infinity,
          tablet: AppDimensions.maxContentWidthTablet,
        ),
        child: AppButton(
          key: const Key('auth_unlock_button'),
          text: context.l10n.unlockWithBiometrics,
          backgroundColor: theme.onVaultGradient,
          foregroundColor: theme.primary,
          onPressed: () {
            context.read<AuthBloc>().add(AuthLoginRequested());
          },
        ),
      ),
    );
  }
}
