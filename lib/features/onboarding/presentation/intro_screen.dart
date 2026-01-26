import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:passvault/features/onboarding/presentation/widgets/onboarding_widgets.dart';

/// Onboarding introduction screen for new users.
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

  void _handleDone(BuildContext context) {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    final slides = [
      IntroSlide(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: Icons.security,
      ),
      IntroSlide(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: Icons.wifi_off,
      ),
      IntroSlide(
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
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
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
                  child: IntroNavigationButtons(
                    currentPage: _currentPage,
                    totalPages: slides.length,
                    onSkip: () => _handleDone(context),
                    onNext: () {
                      if (_currentPage < slides.length - 1) {
                        _pageController.nextPage(
                          duration: AppDuration.normal,
                          curve: AppCurves.standard,
                        );
                      } else {
                        _handleDone(context);
                      }
                    },
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
