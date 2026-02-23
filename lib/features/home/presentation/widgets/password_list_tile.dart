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
    final theme = context.theme;
    final typography = context.typography;

    return Dismissible(
      key: Key(entry.id),
      background: _DismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      child: AppCard(
        hasGlow: false,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.m),
          child: Row(
            children: [
              _PasswordLeadingIcon(appName: entry.appName),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.appName,
                      style: typography.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      entry.username,
                      style: typography.bodyMedium?.copyWith(
                        color: theme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              _CopyButton(password: entry.password),
            ],
          ),
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
