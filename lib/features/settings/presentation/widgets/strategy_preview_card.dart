import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/core/design_system/components/components.dart';
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
      child: BlocBuilder<StrategyPreviewBloc, StrategyPreviewState>(
        builder: (context, state) {
          return _PreviewCardEffect(
            settings: settings,
            child: PasswordPreviewCard(
              password: state.password,
              strength: state.strength,
              onRefresh: () => context.read<StrategyPreviewBloc>().add(
                GeneratePreview(settings),
              ),
              isLoading: state is StrategyPreviewLoading,
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
      final shouldRegenerate =
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
