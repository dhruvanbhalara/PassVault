import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/auth/presentation/bloc/auth/auth_bloc.dart';

/// Screen responsible for biometric and local authentication.
///
/// Acts as the gatekeeper for the application, ensuring the user
/// is authenticated before accessing the vault.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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

class _AuthContent extends StatefulWidget {
  const _AuthContent();

  @override
  State<_AuthContent> createState() => _AuthContentState();
}

class _AuthContentState extends State<_AuthContent> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const AppLoader(key: Key('auth_loading'));
        }

        final isAmoled = theme.primaryGlow != null;

        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
                    // App Logo (shield)
                    _AppLogo(isAmoled: isAmoled),
                    const SizedBox(height: AppSpacing.xxl),
                    // Header
                    Text(
                      context.l10n.unlockVaultTitle,
                      style: context.typography.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isAmoled ? theme.onPrimary : theme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      context.l10n.biometricAuthRequired,
                      style: context.typography.bodyMedium?.copyWith(
                        color: (isAmoled ? theme.onPrimary : theme.onSurface)
                            .withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    // Biometric Shortcut
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onBiometricTap,
                      child: Column(
                        children: [
                          Center(
                            child: Hero(
                              tag: 'biometric_icon',
                              child: IconButton(
                                key: const Key('auth_unlock_button'),
                                iconSize: 80,
                                icon: Icon(
                                  LucideIcons.fingerprintPattern,
                                  color: theme.primary,
                                ),
                                onPressed: onBiometricTap,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          // Unlock Button replacement or label
                          Text(
                            context.l10n.tapToAuthenticate,
                            style: context.typography.labelLarge?.copyWith(
                              color: theme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onBiometricTap() {
    context.read<AuthBloc>().add(const AuthLoginRequested());
  }
}

class _AppLogo extends StatelessWidget {
  final bool isAmoled;

  const _AppLogo({required this.isAmoled});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isAmoled
            ? theme.background.withValues(alpha: 0)
            : theme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: isAmoled ? Border.all(color: theme.primary, width: 2) : null,
        boxShadow: isAmoled
            ? [
                BoxShadow(
                  color: theme.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(LucideIcons.shield, size: 40, color: theme.primary),
    );
  }
}
