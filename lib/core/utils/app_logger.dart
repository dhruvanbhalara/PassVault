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
