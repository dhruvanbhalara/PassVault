import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

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
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthUnauthenticated) {
          final l10n = AppLocalizations.of(context)!;
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
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: theme.vaultGradient),
          child: SafeArea(
            child: Center(
              child: BlocBuilder<AuthBloc, AuthState>(
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
                      RepaintBoundary(
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
                      ),
                      SizedBox(
                        height: context.responsive(
                          AppSpacing.xl,
                          tablet: AppSpacing.xxl,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.appName,
                        key: const Key('auth_title'),
                        style: context.typography.headlineLarge?.copyWith(
                          color: theme.onVaultGradient,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        AppLocalizations.of(context)!.locked,
                        key: const Key('auth_locked_text'),
                        style: context.typography.bodyMedium?.copyWith(
                          color: theme.onVaultGradient.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(
                        height: context.responsive(
                          AppSpacing.xxl,
                          tablet: AppSpacing.xxxl,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsive(
                            AppSpacing.xxl,
                            tablet: AppSpacing.xxxl,
                          ),
                        ),
                        child: SizedBox(
                          width: context.responsive(
                            double.infinity,
                            tablet: AppDimensions.maxContentWidthTablet,
                          ),
                          child: AppButton(
                            key: const Key('auth_unlock_button'),
                            text: AppLocalizations.of(
                              context,
                            )!.unlockWithBiometrics,
                            backgroundColor: theme.onVaultGradient,
                            foregroundColor: theme.primary,
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                AuthLoginRequested(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
