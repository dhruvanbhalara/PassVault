import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('Tokens', () {
    test('$AppSpacing should follow 4/8px grid', () {
      expect(AppSpacing.xs, 4.0);
      expect(AppSpacing.s, 8.0);
      expect(AppSpacing.m, 16.0);
      expect(AppSpacing.l, 24.0);
    });

    test('$AppBreakpoints should be defined for responsive logic', () {
      expect(AppBreakpoints.mobile, 600.0);
      expect(AppBreakpoints.tablet, 1024.0);
    });
  });

  group('$AppColors', () {
    test('Light theme should have defined primary focus color', () {
      final focusColor = AppColors.getPrimaryFocus(Brightness.light);

      expect(focusColor, isA<Color>());
      expect(focusColor, isNot(AppColors.primaryLight));
    });

    test('Dark theme should have high-contrast background pairing', () {
      expect(AppColors.bgDark, const Color(0xFF0F172A));
      expect(AppColors.surfaceDark, const Color(0xFF1E293B));
    });
  });

  group('AppThemeExtension Integration', () {
    testWidgets('BuildContext extension should provide theme properties', (
      tester,
    ) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            final theme = context.theme;
            expect(theme.primary, AppColors.primaryLight);
            expect(theme.vaultGradient, isNotNull);
            expect(theme.inputFocusedBorder, isA<Color>());
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets(
      'Responsive helper should return mobile value on small screens',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpApp(
          Builder(
            builder: (context) {
              final val = context.responsive('mobile', tablet: 'tablet');
              expect(val, 'mobile');
              expect(context.isMobile, true);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'Responsive helper should return tablet value on medium screens',
      (tester) async {
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpApp(
          Builder(
            builder: (context) {
              final val = context.responsive(
                'mobile',
                tablet: 'tablet',
                desktop: 'desktop',
              );
              expect(val, 'tablet');
              expect(context.isTablet, true);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'Responsive helper should return desktop value on large screens',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpApp(
          Builder(
            builder: (context) {
              final val = context.responsive(
                'mobile',
                tablet: 'tablet',
                desktop: 'desktop',
              );
              expect(val, 'desktop');
              expect(context.isDesktop, true);
              expect(context.isTablet, false);
              expect(context.isMobile, false);
              return const SizedBox();
            },
          ),
        );
      },
    );
  });
}
