import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';
import 'package:passvault/features/generator/presentation/widgets/password_feedback_view.dart';
import 'package:passvault/features/generator/presentation/widgets/password_generation_controls_card.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class GeneratorGeneratedPasswordCard extends StatelessWidget {
  final GeneratorLoaded state;

  const GeneratorGeneratedPasswordCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final password = state.generatedPassword.isEmpty
        ? l10n.hintPassword
        : state.generatedPassword;
    return RepaintBoundary(
      child: AppCard(
        hasGlow: context.isAmoled,
        padding: const EdgeInsets.all(AppSpacing.l),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.m,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: PasswordStrengthWidget(strength: state.strength),
              ),
              PasswordFeedbackView(feedback: state.strength),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 76,
                      child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 320),
                        layoutBuilder: (entries) => Stack(children: entries),
                        transitionBuilder:
                            (child, primaryAnimation, secondaryAnimation) =>
                                SharedAxisTransition(
                                  animation: primaryAnimation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.vertical,
                                  fillColor: colorScheme.surface.withValues(
                                    alpha: 0,
                                  ),
                                  child: child,
                                ),
                        child: Align(
                          key: ValueKey(password),
                          alignment: Alignment.centerLeft,
                          child:
                              SelectableText(
                                    password,
                                    minLines: 1,
                                    maxLines: 2,
                                    style: theme.passwordText.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primary,
                                      height: 1.2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                  .animate(key: ValueKey(password))
                                  .fadeIn(
                                    duration: 320.ms,
                                    curve: Curves.easeOut,
                                  )
                                  .slideX(
                                    begin: 0.08,
                                    end: 0,
                                    duration: 320.ms,
                                    curve: Curves.easeOutQuad,
                                  )
                                  .shimmer(
                                    delay: 250.ms,
                                    duration: 850.ms,
                                    color: theme.onSurface.withValues(
                                      alpha: 0.22,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('generator_copy_icon_button'),
                    tooltip: l10n.copyPassword,
                    onPressed: state.generatedPassword.isEmpty
                        ? null
                        : () => _copyPassword(
                            context,
                            password: state.generatedPassword,
                          ),
                    icon: const Icon(LucideIcons.copy),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyPassword(
    BuildContext context, {
    required String password,
  }) async {
    await Clipboard.setData(ClipboardData(text: password));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.passwordCopied)));
  }
}

class GeneratorControlsCard extends StatelessWidget {
  final GeneratorLoaded state;

  const GeneratorControlsCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.settings != null &&
            state.settings!.strategies.isNotEmpty) ...[
          _GeneratorStrategyDropdown(
            strategies: state.settings!.strategies,
            selectedId: state.strategy.id,
            onChanged: (id) {
              if (id != null && id != state.strategy.id) {
                context.read<GeneratorBloc>().add(
                  GeneratorStrategySelected(id),
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.m),
        ],
        PasswordGenerationControlsCard(
          strategy: state.strategy,
          controlsPrefix: 'generator',
          onLengthChanged: (length) =>
              context.read<GeneratorBloc>().add(GeneratorLengthChanged(length)),
          onUppercaseChanged: (value) => context.read<GeneratorBloc>().add(
            GeneratorUppercaseToggled(value),
          ),
          onLowercaseChanged: (value) => context.read<GeneratorBloc>().add(
            GeneratorLowercaseToggled(value),
          ),
          onNumbersChanged: (value) =>
              context.read<GeneratorBloc>().add(GeneratorNumbersToggled(value)),
          onSymbolsChanged: (value) =>
              context.read<GeneratorBloc>().add(GeneratorSymbolsToggled(value)),
          onExcludeAmbiguousChanged: (value) => context
              .read<GeneratorBloc>()
              .add(GeneratorExcludeAmbiguousToggled(value)),
          onWordCountChanged: (count) => context.read<GeneratorBloc>().add(
            GeneratorWordCountChanged(count),
          ),
          onSeparatorChanged: (separator) => context.read<GeneratorBloc>().add(
            GeneratorSeparatorChanged(separator),
          ),
        ),
      ],
    );
  }
}

class _GeneratorStrategyDropdown extends StatelessWidget {
  final List<PasswordGenerationStrategy> strategies;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _GeneratorStrategyDropdown({
    required this.strategies,
    this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DropdownButtonFormField<String>(
      key: const Key('generator_strategy_dropdown'),
      initialValue: selectedId,
      decoration: InputDecoration(
        labelText: l10n.generationStrategy,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
      ),
      items: strategies.map((strategy) {
        return DropdownMenuItem(value: strategy.id, child: Text(strategy.name));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
