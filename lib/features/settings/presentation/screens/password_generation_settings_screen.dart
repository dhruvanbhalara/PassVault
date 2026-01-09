import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;
    final textTheme = context.typography;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passwordGeneration), centerTitle: true),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.passwordSettings;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              _PreviewCard(settings: settings),
              const SizedBox(height: AppSpacing.l),
              Text(
                l10n.passwordLength.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: theme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.s,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.s),
                                  child: Icon(
                                    LucideIcons.ruler,
                                    color: theme.primary,
                                    size: AppIconSize.s,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Text(
                                l10n.passwordLength,
                                style: textTheme.titleMedium,
                              ),
                            ],
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.primary,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.m,
                                vertical: AppSpacing.xs,
                              ),
                              child: Text(
                                '${settings.length}',
                                style: textTheme.titleMedium?.copyWith(
                                  color: theme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: AppDimensions.sliderTrackHeight,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: AppDimensions.sliderThumbRadius,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: AppDimensions.sliderOverlayRadius,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '8',
                              style: textTheme.bodySmall?.copyWith(
                                color: theme.outline,
                              ),
                            ),
                            Text(
                              '64',
                              style: textTheme.bodySmall?.copyWith(
                                color: theme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.characterSets.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
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
                    const Divider(
                      indent: AppDimensions.listTileDividerIndent,
                      height: 1,
                    ),
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
                    const Divider(
                      indent: AppDimensions.listTileDividerIndent,
                      height: 1,
                    ),
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
                    const Divider(
                      indent: AppDimensions.listTileDividerIndent,
                      height: 1,
                    ),
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
    final theme = context.theme;

    return Card(
      color: theme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s,
                children: [
                  Text(
                    AppLocalizations.of(context)!.preview.toUpperCase(),
                    style: context.typography.labelSmall?.copyWith(
                      color: theme.onPrimaryContainer,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    _previewPassword,
                    style: theme.passwordText.copyWith(
                      color: theme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                LucideIcons.refreshCw,
                color: theme.onPrimaryContainer,
                size: AppIconSize.m,
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
