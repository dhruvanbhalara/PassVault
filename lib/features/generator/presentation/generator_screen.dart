import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';

import 'widgets/generator_sections.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const fabSize = 56.0;
    final fabBottomOffset =
        AppSpacing.m + (kBottomNavigationBarHeight - fabSize) / 2 + bottomInset;
    return Scaffold(
      body: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            previous.passwordSettings != current.passwordSettings,
        listener: (context, state) {
          context.read<GeneratorBloc>().add(const GeneratorStarted());
        },
        child: Stack(
          children: [
            CustomScrollView(
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
                      GeneratorLoaded() => _GeneratorContentSliver(
                        state: state,
                      ),
                    };
                  },
                ),
              ],
            ),
            Positioned(
              right: AppSpacing.m,
              bottom: fabBottomOffset,
              child: SizedBox(
                width: fabSize,
                height: fabSize,
                child: FloatingActionButton(
                  key: const Key('generator_generate_fab'),
                  heroTag: 'generator_generate_fab',
                  onPressed: () => context.read<GeneratorBloc>().add(
                    const GeneratorRequested(),
                  ),
                  child: const Icon(LucideIcons.refreshCw),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratorContentSliver extends StatelessWidget {
  final GeneratorLoaded state;

  const _GeneratorContentSliver({required this.state});

  @override
  Widget build(BuildContext context) {
    const fabSize = 56.0;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.l,
        AppSpacing.l + kBottomNavigationBarHeight + bottomInset + fabSize,
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
