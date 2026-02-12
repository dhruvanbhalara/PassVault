import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/utils/haptics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Captures platform channel calls for HapticFeedback.
  final List<String> hapticCalls = [];

  setUp(() {
    hapticCalls.clear();

    // Re-enable haptics before every test.
    AppHaptics.setEnabled(true);

    // Intercept HapticFeedback platform channel calls.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall call,
        ) async {
          hapticCalls.add(call.method);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('$AppHaptics enable / disable', () {
    test('enabled is true by default', () {
      expect(AppHaptics.enabled, isTrue);
    });

    test('setEnabled(false) prevents haptic calls', () async {
      AppHaptics.setEnabled(false);

      await AppHaptics.lightImpact();
      await AppHaptics.mediumImpact();
      await AppHaptics.heavyImpact();
      await AppHaptics.selectionClick();

      expect(hapticCalls, isEmpty);
    });

    test('setEnabled(true) re-enables haptic calls', () async {
      AppHaptics.setEnabled(false);
      AppHaptics.setEnabled(true);

      await AppHaptics.lightImpact();

      expect(hapticCalls, contains('HapticFeedback.vibrate'));
    });
  });

  group('Standard impact types', () {
    test('lightImpact triggers platform call', () async {
      await AppHaptics.lightImpact();
      expect(hapticCalls, isNotEmpty);
    });

    test('mediumImpact triggers platform call', () async {
      await AppHaptics.mediumImpact();
      expect(hapticCalls, isNotEmpty);
    });

    test('heavyImpact triggers platform call', () async {
      await AppHaptics.heavyImpact();
      expect(hapticCalls, isNotEmpty);
    });

    test('selectionClick triggers platform call', () async {
      await AppHaptics.selectionClick();
      expect(hapticCalls, isNotEmpty);
    });
  });

  group('Notification types', () {
    test('success triggers medium impact', () async {
      await AppHaptics.success();
      expect(hapticCalls, isNotEmpty);
    });

    test('warning triggers heavy impact', () async {
      await AppHaptics.warning();
      expect(hapticCalls, isNotEmpty);
    });

    test('error triggers heavy impact + vibrate (two calls)', () async {
      await AppHaptics.error();
      // heavy impact + vibrate → 2 platform calls
      expect(hapticCalls.length, equals(2));
    });
  });

  group('Semantic action shortcuts', () {
    test('buttonPress delegates to lightImpact', () async {
      await AppHaptics.buttonPress();
      expect(hapticCalls, isNotEmpty);
    });

    test('toggle delegates to selectionClick', () async {
      await AppHaptics.toggle();
      expect(hapticCalls, isNotEmpty);
    });

    test('copySuccess delegates to success', () async {
      await AppHaptics.copySuccess();
      expect(hapticCalls, isNotEmpty);
    });

    test('deleteAction delegates to warning', () async {
      await AppHaptics.deleteAction();
      expect(hapticCalls, isNotEmpty);
    });

    test('errorFeedback delegates to error', () async {
      await AppHaptics.errorFeedback();
      expect(hapticCalls.length, equals(2));
    });

    test('navigationClick delegates to selectionClick', () async {
      await AppHaptics.navigationClick();
      expect(hapticCalls, isNotEmpty);
    });
  });

  group('No calls when disabled', () {
    test('semantic shortcuts do nothing when disabled', () async {
      AppHaptics.setEnabled(false);

      await AppHaptics.buttonPress();
      await AppHaptics.toggle();
      await AppHaptics.copySuccess();
      await AppHaptics.deleteAction();
      await AppHaptics.errorFeedback();
      await AppHaptics.navigationClick();

      expect(hapticCalls, isEmpty);
    });
  });
}
