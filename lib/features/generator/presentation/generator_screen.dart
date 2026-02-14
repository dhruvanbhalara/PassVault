import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Text(context.l10n.passwordGenerator),
            floating: true,
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: context.theme.background.withValues(alpha: 0),
          ),
          BlocBuilder<GeneratorBloc, GeneratorState>(
            builder: (context, state) {
              return switch (state) {
                GeneratorLoading() => const SliverFillRemaining(
                  child: Center(child: AppLoader()),
                ),
                GeneratorLoaded() => _GeneratorContentSliver(state: state),
              };
            },
          ),
        ],
      ),
    );
  }
}

class _GeneratorContentSliver extends StatelessWidget {
  final GeneratorLoaded state;

  const _GeneratorContentSliver({required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.l,
        AppSpacing.xxl,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
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
        ]),
      ),
    );
  }
}
