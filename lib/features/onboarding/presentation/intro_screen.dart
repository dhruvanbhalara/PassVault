import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';

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
    context.read<OnboardingBloc>().add(OnboardingSkipped());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final slides = _getSlides(l10n);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          context.go('/auth');
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
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: Text(
                  l10n.appName,
                  style: context.typography.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
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
              _NavigationRow(
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
      _BaseOnboardingSlide(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: LucideIcons.shieldCheck,
        pulseAnimation: _pulseAnimation,
      ),
      _BaseOnboardingSlide(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: LucideIcons.wifiOff,
        pulseAnimation: _pulseAnimation,
      ),
      _BaseOnboardingSlide(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        icon: LucideIcons.sparkles,
        pulseAnimation: _pulseAnimation,
      ),
      _BaseOnboardingSlide(
        title: l10n.headingEnableBiometrics,
        description: l10n.descEnableBiometrics,
        icon: LucideIcons.fingerprintPattern,
        pulseAnimation: _pulseAnimation,
        footer: Column(
          children: [
            _PrivacyInfoCard(l10n: l10n),
            const SizedBox(height: AppSpacing.xl),
            const _BiometricEnableButton(),
          ],
        ),
      ),
    ];
  }
}

class _BiometricEnableButton extends StatelessWidget {
  const _BiometricEnableButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final isAuthenticating = state is BiometricAuthInProgress;
          return AppButton(
            key: const Key('intro_biometric_enable_button'),
            text: l10n.enableNow,
            isLoading: isAuthenticating,
            onPressed: isAuthenticating
                ? null
                : () => context.read<OnboardingBloc>().add(
                    BiometricAuthRequested(),
                  ),
          );
        },
      ),
    );
  }
}

class _NavigationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const _NavigationRow({
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textTheme = context.typography;
    final isLastPage = currentPage == totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip Button
          if (!isLastPage)
            TextButton(
              key: const Key('intro_skip_button'),
              onPressed: onSkip,
              child: Text(
                l10n.skip,
                style: textTheme.bodyMedium?.copyWith(color: colors.secondary),
              ),
            )
          else
            const SizedBox(width: AppSpacing.xxxl),

          _PageIndicators(currentPage: currentPage, totalPages: totalPages),

          // Next/Done Button
          TextButton(
            key: isLastPage
                ? const Key('intro_done_button')
                : const Key('intro_next_button'),
            onPressed: isLastPage ? onSkip : onNext,
            child: Text(
              isLastPage ? l10n.done : l10n.next,
              style: textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicators({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: AppDuration.normal,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? colors.primary
                : colors.secondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    );
  }
}

class _BaseOnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Animation<double> pulseAnimation;
  final Widget? footer;

  const _BaseOnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.pulseAnimation,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          ScaleTransition(
            scale: pulseAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Icon(icon, size: 80, color: context.colors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            style: context.typography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            description,
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xl),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _PrivacyInfoCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _PrivacyInfoCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardBg = colors.surfaceHighlight;
    final iconColor = colors.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: colors.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lockKeyhole, size: 24, color: iconColor),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              l10n.privacyNotice,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
