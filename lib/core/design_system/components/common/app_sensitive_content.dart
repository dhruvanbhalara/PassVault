import 'dart:ui';
import 'package:flutter/material.dart';

/// A utility component that blurs its child to hide sensitive information.
///
/// Tap to reveal functionality can be implemented by the parent by toggling [isBlurred].
class AppSensitiveContent extends StatelessWidget {
  /// The sensitive widget to obscure.
  final Widget child;

  /// Whether the content is currently blurred.
  final bool isBlurred;

  /// Optional blur intensity. Defaults to 8.0.
  final double blurSigma;

  /// Standardized sensitive content wrapper.
  const AppSensitiveContent({
    super.key,
    required this.child,
    required this.isBlurred,
    this.blurSigma = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isBlurred) return child;

    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: child,
      ),
    );
  }
}
