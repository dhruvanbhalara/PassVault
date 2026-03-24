import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/locale/locale_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_panels.dart';

String themeDisplayName(ThemeType type, AppLocalizations l10n) {
  return switch (type) {
    ThemeType.system => l10n.system,
    ThemeType.light => l10n.light,
    ThemeType.dark => l10n.dark,
    ThemeType.amoled => l10n.amoled,
  };
}

String localeDisplayName(Locale locale, AppLocalizations l10n) {
  return switch (locale.languageCode) {
    'en' => l10n.english,
    _ => locale.toLanguageTag(),
  };
}

void showThemePickerSheet(
  BuildContext context, {
  required ThemeType currentThemeType,
  required AppLocalizations l10n,
}) {
  final themeBloc = context.read<ThemeBloc>();
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => ThemePickerSheet(
      currentThemeType: currentThemeType,
      onThemeSelected: (themeType) => themeBloc.add(ThemeChanged(themeType)),
      l10n: l10n,
    ),
  );
}

void showLanguagePickerSheet(
  BuildContext context, {
  required Locale? selectedLocale,
  required AppLocalizations l10n,
}) {
  final localeBloc = context.read<LocaleBloc>();
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => LocalePickerSheet(
      selectedLocale: selectedLocale,
      onLocaleSelected: (locale) => localeBloc.add(ChangeLocale(locale)),
      onSystemLocaleSelected: () => localeBloc.add(const SetSystemLocale()),
      l10n: l10n,
    ),
  );
}

void showClearDatabaseDialog(BuildContext context) {
  final bloc = context.read<ImportExportBloc>();
  final l10n = context.l10n;
  final theme = context.theme;

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.clearDatabaseTitle),
      content: Text(l10n.clearDatabaseMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel, style: TextStyle(color: theme.onSurface)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            bloc.add(const ClearDatabaseEvent());
          },
          style: TextButton.styleFrom(foregroundColor: theme.error),
          child: Text(l10n.clearAll),
        ),
      ],
    ),
  );
}
