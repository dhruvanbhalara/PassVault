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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('generator_generate_fab'),
        heroTag: 'generator_generate_fab',
        onPressed: () =>
            context.read<GeneratorBloc>().add(const GeneratorRequested()),
        child: const Icon(LucideIcons.refreshCw),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.m,
                  AppSpacing.l,
                  AppSpacing.s,
                ),
                child: PageHeader(title: context.l10n.passwordGenerator),
              ),
            ),
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
        AppSpacing.l,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          GeneratorGeneratedPasswordCard(state: state),
          const SizedBox(height: AppSpacing.l),
          GeneratorControlsCard(state: state),
        ]),
      ),
    );
  }
}
