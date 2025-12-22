import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_dimensions.dart';
import 'package:passvault/core/theme/app_theme_extension.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

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

  void onDonePress(BuildContext context) {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
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
        body: SafeArea(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceL,
                  vertical: AppDimensions.spaceXL,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip Button
                    if (_currentPage < slides.length - 1)
                      TextButton(
                        key: const Key('intro_skip_button'),
                        onPressed: () => onDonePress(context),
                        child: Text(
                          l10n.skip,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.secondary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(
                        width: AppDimensions.space3XL,
                      ), // Placeholder for alignment
                    // Indicators
                    Row(
                      children: List.generate(
                        slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? colors.primary
                                : colors.secondary.withValues(alpha: 0.3),
                            borderRadius: AppDimensions.borderRadiusXS,
                          ),
                        ),
                      ),
                    ),

                    // Next/Done Button
                    TextButton(
                      key: const Key('intro_next_button'),
                      onPressed: () {
                        if (_currentPage < slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          onDonePress(context);
                        }
                      },
                      child: Text(
                        _currentPage == slides.length - 1
                            ? l10n.done
                            : l10n.next,
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.primary,
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
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXXL),
              child: Icon(icon, size: 80, color: context.colors.primary),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),
          Text(
            title,
            style: context.typography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            description,
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
