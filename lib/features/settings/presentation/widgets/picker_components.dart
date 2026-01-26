import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class PickerDragHandle extends StatelessWidget {
  const PickerDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        decoration: BoxDecoration(
          color: context.theme.surfaceDim,
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
      ),
    );
  }
}

class PickerOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PickerOption({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _PickerIcon(icon: icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle, style: context.typography.bodySmall),
      trailing: const Icon(LucideIcons.chevronRight),
      onTap: onTap,
    );
  }
}

class _PickerIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _PickerIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Icon(icon, color: color, size: AppIconSize.m),
      ),
    );
  }
}

class PickerDivider extends StatelessWidget {
  const PickerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: AppDimensions.listTileDividerIndent,
      endIndent: AppSpacing.m,
      color: context.theme.outline.withValues(alpha: 0.1),
    );
  }
}
