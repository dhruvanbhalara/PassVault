import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/bloc/generator_bloc.dart';

import 'widgets/generator_sections.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GeneratorView();
  }
}

class _GeneratorView extends StatelessWidget {
  const _GeneratorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.passwordGenerator),
      ),
      body: BlocBuilder<GeneratorBloc, GeneratorState>(
        builder: (context, state) {
          return switch (state) {
            GeneratorLoading() => const Center(child: AppLoader()),
            GeneratorLoaded() => _GeneratorContent(state: state),
          };
        },
      ),
    );
  }
}

class _GeneratorContent extends StatelessWidget {
  final GeneratorLoaded state;

  const _GeneratorContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.l,
        AppSpacing.xxl,
      ),

      children: [
        GeneratorGeneratedPasswordCard(state: state),
        const SizedBox(height: AppSpacing.m),
        AppButton(
          key: const Key('generator_generate_button'),
          text: context.l10n.generateNew,
          icon: LucideIcons.refreshCw,
          onPressed: () =>
              context.read<GeneratorBloc>().add(const GeneratorRequested()),
          hasGlow: false,
        ),
        const SizedBox(height: AppSpacing.l),
        GeneratorControlsCard(state: state),
      ],
    );
  }
}
