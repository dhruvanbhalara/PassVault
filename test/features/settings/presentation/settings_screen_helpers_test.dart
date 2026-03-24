import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/settings_screen_helpers.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await getL10n();
  });

  group('themeDisplayName', () {
    test('returns system string for ThemeType.system', () {
      expect(themeDisplayName(ThemeType.system, l10n), l10n.system);
    });

    test('returns light string for ThemeType.light', () {
      expect(themeDisplayName(ThemeType.light, l10n), l10n.light);
    });

    test('returns dark string for ThemeType.dark', () {
      expect(themeDisplayName(ThemeType.dark, l10n), l10n.dark);
    });

    test('returns amoled string for ThemeType.amoled', () {
      expect(themeDisplayName(ThemeType.amoled, l10n), l10n.amoled);
    });
  });

  group('localeDisplayName', () {
    test('returns english string for en locale', () {
      expect(localeDisplayName(const Locale('en'), l10n), l10n.english);
    });

    test('returns language tag for unsupported locale', () {
      const locale = Locale('fr');
      expect(localeDisplayName(locale, l10n), locale.toLanguageTag());
    });
  });
}
