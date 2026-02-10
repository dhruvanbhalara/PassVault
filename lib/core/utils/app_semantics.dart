import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Utility class providing semantic label helpers for consistent accessibility.
///
/// These helpers wrap widgets with appropriate semantics to ensure the app is
/// accessible to users with screen readers and other assistive technologies.
///
/// Example:
/// ```dart
/// AppSemantics.button(
///   label: 'Save password',
///   hint: 'Saves the current password entry',
///   child: FloatingActionButton(...),
/// )
/// ```
abstract class AppSemantics {
  /// Wraps a widget with button semantics.
  ///
  /// Use for interactive elements that perform actions.
  static Widget button({
    required String label,
    String? hint,
    required Widget child,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      enabled: enabled,
      child: child,
    );
  }

  /// Wraps a widget with header semantics.
  ///
  /// Use for section headers and titles.
  static Widget header({required String label, required Widget child}) {
    return Semantics(header: true, label: label, child: child);
  }

  /// Wraps a widget with list item semantics.
  ///
  /// Use for items in lists or grids.
  static Widget listItem({
    required String label,
    String? hint,
    required Widget child,
    int? indexInList,
  }) {
    return Semantics(label: label, hint: hint, child: child);
  }

  /// Wraps a widget with input field semantics.
  ///
  /// Use for text fields and other input widgets.
  static Widget input({
    required String label,
    String? hint,
    String? value,
    required Widget child,
    bool obscured = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      textField: true,
      obscured: obscured,
      child: child,
    );
  }

  /// Wraps a widget with loading state announcement.
  ///
  /// Use for loading indicators and progress states.
  static Widget loading({String label = 'Loading', required Widget child}) {
    return Semantics(liveRegion: true, label: label, child: child);
  }

  /// Wraps a widget with image semantics.
  ///
  /// Use for icons, images, and visual indicators.
  static Widget image({required String label, required Widget child}) {
    return Semantics(image: true, label: label, child: child);
  }

  /// Wraps a widget with link semantics.
  ///
  /// Use for navigational elements.
  static Widget link({
    required String label,
    String? hint,
    required Widget child,
  }) {
    return Semantics(link: true, label: label, hint: hint, child: child);
  }

  /// Announces a message to screen readers without UI change.
  ///
  /// Use for status updates, errors, or confirmations.
  static void announce(
    BuildContext context,
    String message, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final view = View.of(context);
    SemanticsService.sendAnnouncement(view, message, textDirection);
  }
}
