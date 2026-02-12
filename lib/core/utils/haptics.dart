import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Centralized haptic feedback utility for PassVault.
///
/// Provides consistent, semantically named haptic feedback across the app.
/// All methods are safe to call on any platform — unsupported feedback types
/// are silently ignored.
///
/// ## Platform notes
/// - **iOS:** All feedback types (Taptic Engine) are fully supported.
/// - **Android:** Support varies by device; some may not produce output for
///   every type. Calls still succeed without error.
///
/// ## Performance
/// Haptic calls are fire-and-forget; they do not block the UI thread.
/// Wrap calls in `unawaited()` when you don't need to sequence them.
///
/// ## Usage
/// ```dart
/// // Button tap
/// onPressed: () async {
///   await AppHaptics.buttonPress();
///   doAction();
/// }
///
/// // Copy to clipboard
/// await Clipboard.setData(ClipboardData(text: password));
/// await AppHaptics.copySuccess();
///
/// // Toggle switch
/// onChanged: (value) async {
///   await AppHaptics.toggle();
///   setState(() => enabled = value);
/// }
/// ```
class AppHaptics {
  // Prevent instantiation.
  AppHaptics._();

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------

  static bool _enabled = true;

  /// Whether haptic feedback is currently enabled.
  static bool get enabled => _enabled;

  /// Enable or disable haptic feedback globally.
  ///
  /// When disabled, all feedback methods return immediately without triggering
  /// any platform calls. Useful for a user-facing "Haptics" toggle in Settings.
  static void setEnabled(bool enabled) => _enabled = enabled;

  // ---------------------------------------------------------------------------
  // Standard impact types
  // ---------------------------------------------------------------------------

  /// Light impact — subtle tap, e.g. button presses, list item selection.
  static Future<void> lightImpact() =>
      _performHaptic(HapticFeedback.lightImpact);

  /// Medium impact — moderate tap, e.g. success confirmations.
  static Future<void> mediumImpact() =>
      _performHaptic(HapticFeedback.mediumImpact);

  /// Heavy impact — strong tap, e.g. warnings or destructive confirmations.
  static Future<void> heavyImpact() =>
      _performHaptic(HapticFeedback.heavyImpact);

  /// Selection click — crisp tick for toggles, pickers, and segmented controls.
  static Future<void> selectionClick() =>
      _performHaptic(HapticFeedback.selectionClick);

  // ---------------------------------------------------------------------------
  // Notification types (semantic wrappers over impacts)
  // ---------------------------------------------------------------------------

  /// Positive-outcome notification (medium impact).
  static Future<void> success() => mediumImpact();

  /// Attention / caution notification (heavy impact).
  static Future<void> warning() => heavyImpact();

  /// Error / failure notification (heavy impact + vibrate for emphasis).
  static Future<void> error() async {
    await heavyImpact();
    await _performHaptic(HapticFeedback.vibrate);
  }

  // ---------------------------------------------------------------------------
  // Semantic action shortcuts (map design-prompt requirements → feedback)
  // ---------------------------------------------------------------------------

  /// Button tap — light impact.
  static Future<void> buttonPress() => lightImpact();

  /// Toggle switch / checkbox — selection click.
  static Future<void> toggle() => selectionClick();

  /// Successful copy-to-clipboard — success notification.
  static Future<void> copySuccess() => success();

  /// Destructive / delete action — warning notification.
  static Future<void> deleteAction() => warning();

  /// Error state feedback — error notification.
  static Future<void> errorFeedback() => error();

  /// Tab / navigation change — selection click.
  static Future<void> navigationClick() => selectionClick();

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Safely executes a haptic [feedback] call.
  ///
  /// Returns immediately when haptics are [_enabled] == false.
  /// Any platform error is caught and logged — haptics are non-critical UI
  /// polish and must never crash the app.
  static Future<void> _performHaptic(Future<void> Function() feedback) async {
    if (!_enabled) return;

    try {
      await feedback();
    } catch (e, st) {
      // Silently swallow — haptics are strictly a nice-to-have.
      debugPrint('Haptic feedback failed: $e\n$st');
    }
  }
}
