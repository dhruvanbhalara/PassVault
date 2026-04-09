import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';

class GroupedPasswordListTile extends StatelessWidget {
  final GroupedHomeEntry group;
  final VoidCallback onTap;

  const GroupedPasswordListTile({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSingleAccount = group.accountCount == 1;
    final subtitle = isSingleAccount
        ? ''
        : context.l10n.groupedCredentialCount(group.accountCount);

    return AppCard(
      hasGlow: false,
      child: InkWell(
        key: Key('grouped_password_tile_${group.canonicalKey}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.m),
        child: Row(
          children: [
            _GroupLeadingIcon(label: group.displayName),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.displayName,
                    style: context.typography.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: context.typography.bodyMedium?.copyWith(
                        color: context.theme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isSingleAccount) _GroupCountBadge(count: group.accountCount),
            const SizedBox(width: AppSpacing.s),
            Icon(
              LucideIcons.chevronRight,
              size: AppIconSize.m,
              color: context.theme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLeadingIcon extends StatelessWidget {
  final String label;

  const _GroupLeadingIcon({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.listTileIconSize,
      height: AppDimensions.listTileIconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Center(
          child: Text(
            label.isNotEmpty ? label[0].toUpperCase() : '?',
            style: context.typography.titleMedium?.copyWith(
              color: context.theme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupCountBadge extends StatelessWidget {
  final int count;

  const _GroupCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          count.toString(),
          key: const Key('grouped_password_count_badge'),
          style: context.typography.labelMedium?.copyWith(
            color: context.theme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
