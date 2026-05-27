import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class AppErrorPage extends StatelessWidget {
  final GoException? error;

  const AppErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: PageHeader(title: context.l10n.errorOccurred),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.l),
                  Text(
                    error?.message ?? context.l10n.errorOccurred,
                    textAlign: TextAlign.left,
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
          ],
        ),
      ),
    );
  }
}
