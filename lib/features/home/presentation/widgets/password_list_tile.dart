import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class PasswordListTile extends StatelessWidget {
  final PasswordEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const PasswordListTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.typography;

    return Dismissible(
      key: Key(entry.id),
      background: _DismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      child: AppCard(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          leading: _PasswordLeadingIcon(appName: entry.appName),
          title: Text(entry.appName, style: textTheme.titleMedium),
          subtitle: Text(entry.username, style: textTheme.bodyMedium),
          trailing: _CopyButton(password: entry.password),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _PasswordLeadingIcon extends StatelessWidget {
  final String appName;
  const _PasswordLeadingIcon({required this.appName});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SizedBox(
      width: AppDimensions.listTileIconSize,
      height: AppDimensions.listTileIconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Center(
          child: Text(
            appName.isNotEmpty ? appName[0].toUpperCase() : '?',
            style: context.typography.titleMedium?.copyWith(
              color: theme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  final String password;
  const _CopyButton({required this.password});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.copy, size: AppIconSize.m),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: password));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              content: Text(context.l10n.passwordCopied),
              duration: AppDuration.slow,
            ),
          );
        },
      ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.l),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            LucideIcons.trash2,
            color: context.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
