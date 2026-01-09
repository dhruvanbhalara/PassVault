import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_animations.dart';
import 'package:passvault/core/theme/app_dimensions.dart';
import 'package:passvault/core/theme/app_theme_extension.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Onboarding introduction screen for new users.
///
/// Displays features and security benefits of PassVault before the user starts.
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingBloc>(),
      child: const IntroView(),
    );
  }
}

/// Internal view widget for [IntroScreen] to handle page navigation state.
class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Completes onboarding and navigates to the authentication screen.
  void _handleDone(BuildContext context) {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;
    final textTheme = context.typography;

    final slides = [
      _IntroSlide(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: Icons.security,
      ),
      _IntroSlide(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: Icons.wifi_off,
      ),
      _IntroSlide(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        icon: Icons.fingerprint,
      ),
    ];

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingSuccess) {
          context.go('/auth');
        }
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: theme.vaultGradient),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    key: const Key('intro_page_view'),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: slides,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: context.responsive(
                      AppSpacing.xl,
                      tablet: AppSpacing.xxl,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip Button
                      if (_currentPage < slides.length - 1)
                        TextButton(
                          key: const Key('intro_skip_button'),
                          onPressed: () => _handleDone(context),
                          child: Text(
                            l10n.skip,
                            style: textTheme.bodyMedium?.copyWith(
                              color: theme.onVaultGradient,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: AppSpacing.xxxl),

                      // Progress Indicators
                      Row(
                        children: List.generate(
                          slides.length,
                          (index) => AnimatedContainer(
                            duration: AppDuration.normal,
                            curve: AppCurves.standard,
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                            ),
                            height: AppDimensions.indicatorSize,
                            width: _currentPage == index
                                ? AppDimensions.indicatorWidthLarge
                                : AppDimensions.indicatorSize,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? theme.primary
                                  : theme.onVaultGradient.withValues(
                                      alpha: 0.3,
                                    ),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                          ),
                        ),
                      ),

                      // Navigation Button (Next/Done)
                      TextButton(
                        key: const Key('intro_next_button'),
                        onPressed: () {
                          if (_currentPage < slides.length - 1) {
                            _pageController.nextPage(
                              duration: AppDuration.normal,
                              curve: AppCurves.standard,
                            );
                          } else {
                            _handleDone(context);
                          }
                        },
                        child: Text(
                          _currentPage == slides.length - 1
                              ? l10n.done
                              : l10n.next,
                          style: textTheme.titleMedium?.copyWith(
                            color: theme.onVaultGradient,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A single onboarding slide with an icon, title, and description.
class _IntroSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _IntroSlide({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final iconSize = context.responsive(
      AppDimensions.onboardingIconSize,
      tablet: AppDimensions.onboardingIconSizeTablet,
      desktop: AppDimensions.onboardingIconSizeDesktop,
    );

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    context.responsive(AppSpacing.xxl, tablet: AppSpacing.xxxl),
                  ),
                  child: Icon(icon, size: iconSize, color: theme.primary),
                ),
              ),
              SizedBox(
                height: context.responsive(
                  AppSpacing.xxl,
                  tablet: AppSpacing.xxxl,
                ),
              ),
              Text(
                title,
                style: context.typography.headlineMedium?.copyWith(
                  color: theme.onVaultGradient,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                description,
                style: context.typography.bodyMedium?.copyWith(
                  color: theme.onVaultGradient.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
