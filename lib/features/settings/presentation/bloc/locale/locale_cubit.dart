import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Stores the app locale override.
///
/// `null` means use system locale.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  void setSystemLocale() => emit(null);

  void setLocale(Locale locale) => emit(locale);
}
