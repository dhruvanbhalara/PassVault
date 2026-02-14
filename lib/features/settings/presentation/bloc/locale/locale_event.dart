part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class SetSystemLocale extends LocaleEvent {
  const SetSystemLocale();
}

class ChangeLocale extends LocaleEvent {
  final Locale locale;
  const ChangeLocale(this.locale);

  @override
  List<Object?> get props => [locale];
}
