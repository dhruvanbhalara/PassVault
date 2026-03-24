import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/password_strength_widget.dart';
import 'package:passvault/core/design_system/components/feedback/app_loader.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';

class StrategyPreviewCard extends StatelessWidget {
  final PasswordGenerationStrategy settings;

  const StrategyPreviewCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<StrategyPreviewBloc>()..add(GeneratePreview(settings)),
      child: _PreviewCardContent(settings: settings),
    );
  }
}

class _PreviewCardContent extends StatelessWidget {
  final PasswordGenerationStrategy settings;

  const _PreviewCardContent({required this.settings});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StrategyPreviewBloc, StrategyPreviewState>(
      listener: (context, state) {
        if (state is StrategyPreviewFailure) {
          // Ideally show a snackbar or error indication
        }
      },
      child: BlocBuilder<StrategyPreviewBloc, StrategyPreviewState>(
        builder: (context, state) {
          return _PreviewCardEffect(
            settings: settings,
            child: _PreviewCardView(
              settings: settings,
              state: state,
              onRefresh: () {
                context.read<StrategyPreviewBloc>().add(
                  GeneratePreview(settings),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PreviewCardEffect extends StatefulWidget {
  final PasswordGenerationStrategy settings;
  final Widget child;
  const _PreviewCardEffect({required this.settings, required this.child});

  @override
  State<_PreviewCardEffect> createState() => _PreviewCardEffectState();
}

class _PreviewCardEffectState extends State<_PreviewCardEffect> {
  @override
  void didUpdateWidget(covariant _PreviewCardEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      final oldS = oldWidget.settings;
      final newS = widget.settings;
      bool shouldRegenerate =
          oldS.type != newS.type ||
          oldS.length != newS.length ||
          oldS.wordCount != newS.wordCount ||
          oldS.separator != newS.separator ||
          oldS.useNumbers != newS.useNumbers ||
          oldS.useSpecialChars != newS.useSpecialChars ||
          oldS.useUppercase != newS.useUppercase ||
          oldS.useLowercase != newS.useLowercase ||
          oldS.excludeAmbiguousChars != newS.excludeAmbiguousChars;

      if (shouldRegenerate) {
        context.read<StrategyPreviewBloc>().add(
          GeneratePreview(widget.settings),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _PreviewCardView extends StatelessWidget {
  final PasswordGenerationStrategy settings;
  final StrategyPreviewState state;
  final VoidCallback onRefresh;

  const _PreviewCardView({
    required this.settings,
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final textTheme = context.typography;
    final colorScheme = context.colorScheme;

    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: theme.vaultGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            theme.cardShadow,
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.preview.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      color: theme.onVaultGradient.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  _RefreshButton(
                    onTap: onRefresh,
                    color: theme.onVaultGradient,
                    isLoading: state is StrategyPreviewLoading,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 76,
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 350),
                  layoutBuilder: (entries) => Stack(children: entries),
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) =>
                          SharedAxisTransition(
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.vertical,
                            fillColor: colorScheme.surface.withValues(alpha: 0),
                            child: child,
                          ),
                  child: state is StrategyPreviewLoading
                      ? const Align(
                          key: ValueKey('preview_loader_shell'),
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 40,
                            child: Center(
                              child: AppLoader(
                                key: ValueKey('preview_loader'),
                                size: AppIconSize.m,
                              ),
                            ),
                          ),
                        )
                      : Align(
                          key: ValueKey('preview_text_${state.password}'),
                          alignment: Alignment.centerLeft,
                          child:
                              SelectableText(
                                    state.password,
                                    maxLines: 2,
                                    style: theme.passwordText.copyWith(
                                      fontSize: 22,
                                      color: theme.onVaultGradient,
                                      height: 1.4,
                                    ),
                                  )
                                  .animate(key: ValueKey(state.password))
                                  .fadeIn(
                                    duration: 400.ms,
                                    curve: Curves.easeOut,
                                  )
                                  .slideX(
                                    begin: 0.08,
                                    end: 0,
                                    duration: 400.ms,
                                    curve: Curves.easeOutQuad,
                                  )
                                  .shimmer(
                                    delay: 400.ms,
                                    duration: 900.ms,
                                    color: theme.onVaultGradient.withValues(
                                      alpha: 0.24,
                                    ),
                                  ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: theme.surface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                child: PasswordStrengthWidget(
                  strength: state.strength,
                  labelColor: theme.onVaultGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;

  const _RefreshButton({
    required this.onTap,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        key: const Key('strategy_preview_refresh_button'),
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: Icon(LucideIcons.refreshCw, color: color, size: 18)
              .animate(
                target: isLoading ? 1 : 0,
                onPlay: (controller) => controller.repeat(),
              )
              .rotate(duration: 1.seconds)
              .fadeIn(duration: 200.ms),
        ),
      ),
    );
  }
}
