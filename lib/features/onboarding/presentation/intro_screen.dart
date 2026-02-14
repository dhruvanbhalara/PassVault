import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_components.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _skipBiometric() {
    AppLogger.info('User skipped biometric setup', tag: 'IntroScreen');
    context.read<OnboardingBloc>().add(const OnboardingSkipped());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final slides = _getSlides(l10n);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          context.go(AppRoutes.auth);
        } else if (state is BiometricAuthFailure) {
          final theme = context.theme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.error,
              behavior: SnackBarBehavior.floating,
              duration: AppDuration.normal,
            ),
          );
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
              NavigationRow(
                currentPage: _currentPage,
                totalPages: slides.length,
                onSkip: _skipBiometric,
                onNext: () {
                  _pageController.nextPage(
                    duration: AppDuration.normal,
                    curve: AppCurves.standard,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getSlides(AppLocalizations l10n) {
    return [
      BaseOnboardingSlide(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: LucideIcons.shieldCheck,
        pulseAnimation: _pulseAnimation,
      ),
      BaseOnboardingSlide(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: LucideIcons.wifiOff,
        pulseAnimation: _pulseAnimation,
      ),
      BaseOnboardingSlide(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        icon: LucideIcons.sparkles,
        pulseAnimation: _pulseAnimation,
      ),
      BaseOnboardingSlide(
        title: l10n.headingEnableBiometrics,
        description: l10n.descEnableBiometrics,
        icon: LucideIcons.fingerprintPattern,
        pulseAnimation: _pulseAnimation,
        footer: Column(
          children: [
            PrivacyInfoCard(l10n: l10n),
            const SizedBox(height: AppSpacing.xl),
            const BiometricEnableButton(),
          ],
        ),
      ),
    ];
  }
}
