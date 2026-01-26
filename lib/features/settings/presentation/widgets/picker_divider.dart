import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

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
