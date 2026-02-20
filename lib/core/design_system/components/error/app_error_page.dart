import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class AppErrorPage extends StatelessWidget {
  final GoException? error;

  const AppErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.errorOccurred)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error?.message ?? context.l10n.errorOccurred,
              textAlign: TextAlign.center,
              style: context.typography.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.l),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: Text(context.l10n.home),
            ),
          ],
        ),
      ),
    );
  }
}
