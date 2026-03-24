import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/services/screen_privacy_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$ScreenPrivacyService', () {
    const channel = MethodChannel(
      'com.dhruvanbhalara.passvault/screen_privacy',
    );

    final List<MethodCall> log = [];
    late ScreenPrivacyService service;

    setUp(() {
      log.clear();
      service = ScreenPrivacyService();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            log.add(call);
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    group('enableProtection()', () {
      test('invokes enableScreenProtection on the MethodChannel', () async {
        await service.enableProtection();

        expect(log, hasLength(1));
        expect(log.single.method, 'enableScreenProtection');
      });

      test('calling twice sends two enableScreenProtection calls', () async {
        await service.enableProtection();
        await service.enableProtection();

        expect(log, hasLength(2));
        expect(log[0].method, 'enableScreenProtection');
        expect(log[1].method, 'enableScreenProtection');
      });
    });

    group('disableProtection()', () {
      test('invokes disableScreenProtection on the MethodChannel', () async {
        await service.disableProtection();

        expect(log, hasLength(1));
        expect(log.single.method, 'disableScreenProtection');
      });

      test('calling twice sends two disableScreenProtection calls', () async {
        await service.disableProtection();
        await service.disableProtection();

        expect(log, hasLength(2));
        expect(log[0].method, 'disableScreenProtection');
        expect(log[1].method, 'disableScreenProtection');
      });
    });

    group('enable then disable', () {
      test('sends calls in the correct order', () async {
        await service.enableProtection();
        await service.disableProtection();

        expect(log, hasLength(2));
        expect(log[0].method, 'enableScreenProtection');
        expect(log[1].method, 'disableScreenProtection');
      });
    });

    group('disable then enable', () {
      test('sends calls in the correct order', () async {
        await service.disableProtection();
        await service.enableProtection();

        expect(log, hasLength(2));
        expect(log[0].method, 'disableScreenProtection');
        expect(log[1].method, 'enableScreenProtection');
      });
    });
  });
}
