import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A persistent bottom bar that can hide on scroll and mimics a floating style.
class PersistentBottomBar extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final bool isVisible;

  const PersistentBottomBar({
    super.key,
    required this.child,
    this.scrollController,
    this.isVisible = true,
  });

  @override
  State<PersistentBottomBar> createState() => _PersistentBottomBarState();
}

class _PersistentBottomBarState extends State<PersistentBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.fast,
      value: widget.isVisible ? 0.0 : 1.0,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.scrollController?.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(PersistentBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_handleScroll);
      widget.scrollController?.addListener(_handleScroll);
    }
  }

  void _handleScroll() {
    if (widget.scrollController == null) return;

    final direction = widget.scrollController!.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && _isVisible) {
      _hide();
    } else if (direction == ScrollDirection.forward && !_isVisible) {
      _show();
    }
  }

  void _hide() {
    setState(() => _isVisible = false);
    _controller.forward();
  }

  void _show() {
    setState(() => _isVisible = true);
    _controller.reverse();
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We wrap in a SafeArea to ensure it respects bottom padding
    // but the animation moves the whole thing down.
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.l,
          AppSpacing.s,
          AppSpacing.l,
          AppSpacing.l + MediaQuery.paddingOf(context).bottom,
        ),
        // Use a transparent container for the "floating" look,
        // relying on the child (FAB) to provide the visual substance.
        // We remove the border to avoid a "cut off" line.
        child: Center(heightFactor: 1.0, child: widget.child),
      ),
    );
  }
}
