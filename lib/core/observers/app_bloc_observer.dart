import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/core/utils/app_logger.dart';

/// BLoC observer that logs all BLoC events, transitions, and errors.
///
/// This observer provides comprehensive logging of BLoC lifecycle events:
/// - onCreate: When a BLoC is instantiated
/// - onEvent: When an event is added to a BLoC
/// - onChange: When a state change occurs (both BLoC and Cubit)
/// - onTransition: When a BLoC transitions from one state to another
/// - onError: When an error occurs during event processing
/// - onClose: When a BLoC is closed/disposed
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.debug('Created: ${bloc.runtimeType}', tag: 'BLoC');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug('Event: ${bloc.runtimeType} | $event', tag: 'BLoC');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      'Change: ${bloc.runtimeType} | ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
      tag: 'BLoC',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.debug(
      'Transition: ${bloc.runtimeType} | ${transition.event.runtimeType} -> ${transition.nextState.runtimeType}',
      tag: 'BLoC',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error(
      'ERROR in ${bloc.runtimeType}',
      tag: 'BLoC',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    AppLogger.debug('Closed: ${bloc.runtimeType}', tag: 'BLoC');
  }
}
