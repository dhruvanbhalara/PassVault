import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A standardized loading indicator.
///
/// Wraps [CircularProgressIndicator] to ensure consistent coloring
/// across the app, adapting to the current theme.
class AppLoader extends StatelessWidget {
  /// The size of the loader. Defaults to 24.0.
  final double size;

  /// Optional color override. If null, uses [AppThemeExtension.primary].
  final Color? color;

  /// Standardized application loader.
  const AppLoader({super.key, this.size = 24.0, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? theme.primary),
        ),
      ),
    );
  }
}
