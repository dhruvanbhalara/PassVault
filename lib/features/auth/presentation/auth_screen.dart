import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_dimensions.dart';
import 'package:passvault/core/theme/app_theme_extension.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

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

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        }
      },
      child: Scaffold(
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colors.primary.withValues(alpha: 0.05),
                  context.colors.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator(
                        key: Key('auth_loading'),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RepaintBoundary(
                          child: SizedBox(
                            height: 180,
                            child: Lottie.asset(
                              'assets/animations/fingerprint.json',
                              repeat: true,
                              animate: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceXL),
                        Text(
                          AppLocalizations.of(context)!.appName,
                          key: const Key('auth_title'),
                          style: context.typography.headlineLarge,
                        ),
                        const SizedBox(height: AppDimensions.spaceS),
                        Text(
                          AppLocalizations.of(context)!.locked,
                          key: const Key('auth_locked_text'),
                          style: context.typography.bodyMedium,
                        ),
                        const SizedBox(height: AppDimensions.spaceXXL),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key('auth_unlock_button'),
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  AuthLoginRequested(),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.unlockWithBiometrics,
                              ),
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
      ),
    );
  }
}
