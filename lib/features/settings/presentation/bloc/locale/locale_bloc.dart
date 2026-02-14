import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'locale_event.dart';
part 'locale_state.dart';

@lazySingleton
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(null)) {
    on<SetSystemLocale>((event, emit) => emit(const LocaleState(null)));
    on<ChangeLocale>((event, emit) => emit(LocaleState(event.locale)));
  }
}
