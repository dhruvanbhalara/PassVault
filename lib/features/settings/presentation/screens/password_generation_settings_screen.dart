import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/design_system.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.passwordGeneration,
        ), // Ensure this key exists or use generic text for now
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.passwordSettings;

          return ListView(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            children: [
              _PreviewCard(settings: settings),
              const SizedBox(height: DesignSystem.spacingL),
              Text(
                l10n.passwordLength.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(DesignSystem.spacingM),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  LucideIcons.ruler,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.passwordLength,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${settings.length}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignSystem.spacingM),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 20,
                          ),
                        ),
                        child: Slider(
                          value: settings.length.toDouble(),
                          min: 8,
                          max: 64,
                          divisions: 56,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                              UpdatePasswordSettings(
                                settings.copyWith(length: value.round()),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '8',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                            Text(
                              '64',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Text(
                l10n.characterSets.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(LucideIcons.caseUpper),
                      title: Text(l10n.uppercase),
                      subtitle: Text(l10n.uppercaseHint),
                      value: settings.useUppercase,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePasswordSettings(
                            settings.copyWith(useUppercase: value),
                          ),
                        );
                      },
                    ),
                    const Divider(indent: 56, height: 1),
                    SwitchListTile(
                      secondary: const Icon(LucideIcons.caseLower),
                      title: Text(l10n.lowercase),
                      subtitle: Text(l10n.lowercaseHint),
                      value: settings.useLowercase,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePasswordSettings(
                            settings.copyWith(useLowercase: value),
                          ),
                        );
                      },
                    ),
                    const Divider(indent: 56, height: 1),
                    SwitchListTile(
                      secondary: const Icon(LucideIcons.hash),
                      title: Text(l10n.numbers),
                      subtitle: Text(l10n.numbersHint),
                      value: settings.useNumbers,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePasswordSettings(
                            settings.copyWith(useNumbers: value),
                          ),
                        );
                      },
                    ),
                    const Divider(indent: 56, height: 1),
                    SwitchListTile(
                      secondary: const Icon(LucideIcons.asterisk),
                      title: Text(l10n.specialCharacters),
                      subtitle: Text(l10n.specialCharsHint),
                      value: settings.useSpecialChars,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePasswordSettings(
                            settings.copyWith(useSpecialChars: value),
                          ),
                        );
                      },
                    ),
                    const Divider(indent: 56, height: 1),
                    SwitchListTile(
                      secondary: const Icon(LucideIcons.eyeOff),
                      title: Text(l10n.excludeAmbiguous),
                      subtitle: Text(l10n.excludeAmbiguousHint),
                      value: settings.excludeAmbiguousChars,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePasswordSettings(
                            settings.copyWith(excludeAmbiguousChars: value),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PreviewCard extends StatefulWidget {
  final PasswordGenerationSettings settings;

  const _PreviewCard({required this.settings});

  @override
  State<_PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<_PreviewCard> {
  late String _previewPassword;

  @override
  void initState() {
    super.initState();
    _generatePreview();
  }

  @override
  void didUpdateWidget(_PreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _generatePreview();
    }
  }

  void _generatePreview() {
    // Safety check: ensure at least one set is selected to prevent crashes
    // If all are false, we force lowercase
    var safeSettings = widget.settings;
    if (!widget.settings.useUppercase &&
        !widget.settings.useNumbers &&
        !widget.settings.useSpecialChars &&
        !widget.settings.useLowercase) {
      safeSettings = safeSettings.copyWith(useLowercase: true);
    }

    try {
      _previewPassword = getIt<GeneratePasswordUseCase>()(
        length: safeSettings.length,
        useNumbers: safeSettings.useNumbers,
        useSpecialChars: safeSettings.useSpecialChars,
        useUppercase: safeSettings.useUppercase,
        useLowercase: safeSettings.useLowercase,
        excludeAmbiguousChars: safeSettings.excludeAmbiguousChars,
      );
    } catch (e) {
      _previewPassword = '...';
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingL,
          vertical: DesignSystem.spacingM,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.preview.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingS),
                  Text(
                    _previewPassword,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                LucideIcons.refreshCw,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onPressed: _generatePreview,
              tooltip: AppLocalizations.of(context)!.refreshPreview,
            ),
          ],
        ),
      ),
    );
  }
}
