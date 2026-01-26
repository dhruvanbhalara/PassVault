import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class PasswordPreviewCard extends StatefulWidget {
  final PasswordGenerationSettings settings;

  const PasswordPreviewCard({super.key, required this.settings});

  @override
  State<PasswordPreviewCard> createState() => _PasswordPreviewCardState();
}

class _PasswordPreviewCardState extends State<PasswordPreviewCard> {
  late String _previewPassword;

  @override
  void initState() {
    super.initState();
    _generatePreview();
  }

  @override
  void didUpdateWidget(PasswordPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) _generatePreview();
  }

  void _generatePreview() {
    var safeSettings = widget.settings;
    if (!widget.settings.useAny) {
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
            Expanded(child: _PreviewContent(password: _previewPassword)),
            IconButton(
              icon: Icon(
                LucideIcons.refreshCw,
                color: theme.onPrimaryContainer,
                size: AppIconSize.m,
              ),
              onPressed: _generatePreview,
              tooltip: context.l10n.refreshPreview,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewContent extends StatelessWidget {
  final String password;
  const _PreviewContent({required this.password});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s,
      children: [
        Text(
          context.l10n.preview.toUpperCase(),
          style: context.typography.labelSmall?.copyWith(
            color: theme.onPrimaryContainer,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          password,
          style: theme.passwordText.copyWith(color: theme.onPrimaryContainer),
        ),
      ],
    );
  }
}

extension on PasswordGenerationSettings {
  bool get useAny =>
      useUppercase || useNumbers || useSpecialChars || useLowercase;
}
