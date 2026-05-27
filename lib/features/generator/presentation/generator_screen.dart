import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return AppFeatureShell(
      title: context.l10n.passwordGenerator,
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.l,
        AppSpacing.l + kBottomNavigationBarHeight + bottomInset + AppSpacing.xl,
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
