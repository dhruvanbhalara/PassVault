import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == StrategyPreviewStatus.failure) {
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
          oldS.length != newS.length ||
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
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          theme.cardShadow,
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.preview.toUpperCase(),
                style: context.typography.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              InkWell(
                onTap: onRefresh,
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Icon(
                    LucideIcons.refreshCw,
                    color: theme.primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          SelectableText(
            state.password,
            style: context.typography.headlineSmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
