import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';

import 'widgets/generator_sections.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  int _refreshTick = 0;

  void _handleGenerate() {
    setState(() => _refreshTick++);
    context.read<GeneratorBloc>().add(const GeneratorRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AppFeatureShell(
      title: context.l10n.passwordGenerator,
      floatingActionButton: FloatingActionButton(
        key: const Key('generator_generate_fab'),
        heroTag: 'generator_generate_fab',
        onPressed: _handleGenerate,
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        child: Icon(
          LucideIcons.refreshCw,
          key: ValueKey(_refreshTick),
          size: AppIconSize.l,
        ).animate().rotate(duration: 650.ms, curve: Curves.easeOutCubic),
      ),
      bodyWrapper: (context, child) {
        return BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) =>
              previous.passwordSettings != current.passwordSettings,
          listener: (context, state) {
            context.read<GeneratorBloc>().add(const GeneratorStarted());
          },
          child: child,
        );
      },
      slivers: [
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
