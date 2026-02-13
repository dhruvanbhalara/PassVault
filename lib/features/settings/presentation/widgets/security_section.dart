import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';

/// Section for security-related settings.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsBloc = context.read<SettingsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: l10n.security,
          variant: AppSectionHeaderVariant.premium,
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                key: const Key('settings_password_gen_tile'),
                leading: const Icon(LucideIcons.keyRound),
                title: Text(l10n.passwordGeneration),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () => context.push(
                  AppRoutes.passwordGeneration,
                  extra: context.read<SettingsBloc>(),
                ),
              ),
              const Divider(
                indent: AppDimensions.listTileDividerIndent,
                height: 1,
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return switch (state) {
                    SettingsInitial(:final useBiometrics) ||
                    SettingsLoading(:final useBiometrics) ||
                    SettingsLoaded(:final useBiometrics) ||
                    SettingsFailure(:final useBiometrics) => SwitchListTile(
                      key: const Key('settings_biometric_switch'),
                      secondary: const Icon(LucideIcons.shieldCheck),
                      title: Text(l10n.useBiometrics),
                      value: useBiometrics,
                      onChanged: (value) {
                        settingsBloc.add(ToggleBiometrics(value));
                      },
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
