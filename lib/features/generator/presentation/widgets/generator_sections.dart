import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final l10n = context.l10n;
    final password = state.generatedPassword.isEmpty
        ? l10n.hintPassword
        : state.generatedPassword;

    return Column(
      children: [
        PasswordPreviewCard(
          password: password,
          strength: state.strength,
          onRefresh: () =>
              context.read<GeneratorBloc>().add(const GeneratorRequested()),
          onCopy: state.generatedPassword.isEmpty
              ? null
              : () => _copyPassword(context, password: state.generatedPassword),
          isLoading: false, // GeneratorBloc handles state updates
        ),
        PasswordFeedbackView(feedback: state.strength),
      ],
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
