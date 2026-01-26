import 'package:flutter/material.dart';
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
