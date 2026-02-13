import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class PasswordDetailScreen extends StatefulWidget {
  const PasswordDetailScreen({required this.passwordId, super.key});
  final String passwordId;

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isAmoled = context.isAmoled;
    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Text(l10n.entryDetails),
            floating: true,
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: theme.background.withValues(alpha: 0),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.pencil, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.l),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.xl),
                // Header Card
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.l),
                          border: Border.all(
                            color: theme.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          LucideIcons.shield,
                          size: 36,
                          color: theme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        'Google Account',
                        style: context.typography.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'google.com',
                        style: context.typography.bodyMedium?.copyWith(
                          color: theme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Credentials Card
                AppCard(
                  hasGlow: isAmoled,
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: LucideIcons.user,
                        label: l10n.usernameEmailLabel,
                        value: 'john.doe@gmail.com',
                        onCopy: () {},
                      ),
                      const Divider(height: AppSpacing.xl),
                      _DetailRow(
                        icon: LucideIcons.key,
                        label: l10n.passwordLabel,
                        value: _obscurePassword ? '••••••••' : 'S3cur3P@ss!',
                        isPassword: !_obscurePassword,
                        onCopy: () {},
                        onToggleVisibility: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        isObscured: _obscurePassword,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                // Metadata Card
                AppCard(
                  hasGlow: isAmoled,
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: LucideIcons.calendar,
                        label: l10n.createdOnLabel,
                        value: 'January 12, 2026',
                      ),
                      const Divider(height: AppSpacing.xl),
                      _DetailRow(
                        icon: LucideIcons.history,
                        label: l10n.lastModifiedLabel,
                        value: '2 days ago',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  text: l10n.launchWebsite,
                  onPressed: () {},
                  hasGlow: isAmoled,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;
  final VoidCallback? onToggleVisibility;
  final bool isPassword;
  final bool isObscured;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
    this.onToggleVisibility,
    this.isPassword = false,
    this.isObscured = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typography.labelSmall?.copyWith(
            color: theme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Row(
          children: [
            Icon(icon, size: 18, color: theme.primary.withValues(alpha: 0.7)),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: SelectableText(
                value,
                style: isPassword
                    ? theme.passwordText.copyWith(fontSize: 18)
                    : context.typography.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
              ),
            ),
            if (onToggleVisibility != null)
              IconButton(
                icon: Icon(
                  isObscured ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 18,
                ),
                onPressed: onToggleVisibility,
              ),
            if (onCopy != null)
              IconButton(
                icon: const Icon(LucideIcons.copy, size: 18),
                onPressed: onCopy,
              ),
          ],
        ),
      ],
    );
  }
}
