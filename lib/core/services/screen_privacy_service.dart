import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Manages platform-native screen privacy protection.
///
/// **Android:** Toggles `WindowManager.LayoutParams.FLAG_SECURE` to block
/// screenshots, screen recordings, and screen sharing at the OS level.
///
/// **iOS:** Adds / removes an invisible `UITextField` with
/// `isSecureTextEntry = true` to the key window. UIKit marks the window layer
/// as sensitive so iOS renders blank content for ALL capture mechanisms:
/// - System screenshot gesture
/// - App-switcher snapshots (SpringBoard renders blank — no timing dependency)
/// - Screen recordings (ReplayKit, QuickTime)
/// - AirPlay / Sidecar mirroring
///
/// The protection state is persisted to [flutter_secure_storage] / Hive by
/// [SettingsBloc] and re-applied on every app launch.
@lazySingleton
class ScreenPrivacyService {
  static const _channel = MethodChannel(
    'com.dhruvanbhalara.passvault/screen_privacy',
  );

  /// Enables native screen privacy protection on the current platform.
  Future<void> enableProtection() async {
    await _channel.invokeMethod<void>('enableScreenProtection');
  }

  /// Disables native screen privacy protection.
  Future<void> disableProtection() async {
    await _channel.invokeMethod<void>('disableScreenProtection');
  }
}
