import 'dart:developer' as developer;

/// Centralized logging utility for PassVault.
///
/// Provides structured logging with different severity levels.
/// Uses dart:developer for better debugging and production logging.
class AppLogger {
  /// Log debug information (development only)
  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'PassVault',
      level: 500, // Debug level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log informational messages
  static void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'PassVault',
      level: 800, // Info level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log warnings
  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'PassVault',
      level: 900, // Warning level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log errors
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'PassVault',
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log critical errors that require immediate attention
  static void critical(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'PassVault',
      level: 1200, // Critical level
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Extension to provide easy logging on any Object.
extension AppLoggerObjectX on Object {
  /// Log debug info with the class name as tag.
  void logDebug(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.debug(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info with the class name as tag.
  void logInfo(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.info(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log warning with the class name as tag.
  void logWarning(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.warning(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log error with the class name as tag.
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.error(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
