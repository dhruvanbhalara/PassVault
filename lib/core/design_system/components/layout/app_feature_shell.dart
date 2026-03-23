import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/components/common/page_header.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class AppFeatureShell extends StatelessWidget {
  final String title;
  final List<Widget> slivers;
  final bool showBack;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final Widget Function(BuildContext context, Widget child)? bodyWrapper;

  const AppFeatureShell({
    super.key,
    required this.title,
    required this.slivers,
    this.showBack = false,
    this.onBack,
    this.backgroundColor,
    this.floatingActionButton,
    this.bodyWrapper,
  });

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: bodyWrapper?.call(context, body) ?? body,
    );
  }

  Widget _buildBody(BuildContext context) {
    final scrollView = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.m,
                AppSpacing.l,
                AppSpacing.s,
              ),
              child: PageHeader(
                title: title,
                showBack: showBack,
                onBack: onBack,
              ),
            ),
          ),
        ),
        ...slivers,
      ],
    );

    if (floatingActionButton == null) {
      return scrollView;
    }

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const fabSize = 56.0;
    final fabBottomOffset =
        AppSpacing.m + (kBottomNavigationBarHeight - fabSize) / 2 + bottomInset;

    return Stack(
      children: [
        scrollView,
        Positioned(
          right: AppSpacing.m,
          bottom: fabBottomOffset,
          child: SizedBox(
            width: fabSize,
            height: fabSize,
            child: floatingActionButton!,
          ),
        ),
      ],
    );
  }
}
