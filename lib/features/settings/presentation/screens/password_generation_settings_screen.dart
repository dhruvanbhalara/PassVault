import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/character_set_settings_card.dart';
import 'package:passvault/features/settings/presentation/widgets/password_length_card.dart';
import 'package:passvault/features/settings/presentation/widgets/password_preview_card.dart';

/// Screen to configure password generation preferences.
class PasswordGenerationSettingsScreen extends StatelessWidget {
  const PasswordGenerationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadSettings()),
      child: const _PasswordGenerationSettingsView(),
    );
  }
}

class _PasswordGenerationSettingsView extends StatelessWidget {
  const _PasswordGenerationSettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passwordGeneration), centerTitle: true),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.passwordSettings;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              PasswordPreviewCard(settings: settings),
              const SizedBox(height: AppSpacing.l),
              _SectionHeader(
                title: l10n.passwordLength.toUpperCase(),
                color: theme.primary,
              ),
              const SizedBox(height: AppSpacing.m),
              PasswordLengthCard(settings: settings),
              const SizedBox(height: AppSpacing.xl),
              _SectionHeader(
                title: l10n.characterSets.toUpperCase(),
                color: theme.primary,
              ),
              const SizedBox(height: AppSpacing.m),
              CharacterSetSettingsCard(settings: settings),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.typography.labelLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }
}
