import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:lifely/src/core/logging/logger.dart';

/// Prints logs in debug builds and sends severe errors to Crashlytics.
class const AppLogger({
  /// False in tests, where Firebase isn't set up.
  final bool reportToCrashlytics = true,
}) implements Logger {
  @override
  void info(String message) => _print('INFO', message);

  @override
  void warning(String message) => _print('WARNING', message);

  @override
  void severe(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    _print('SEVERE', message);
    if (error != null) _print('SEVERE', 'Error: $error');
    if (stackTrace != null) _print('SEVERE', 'StackTrace: $stackTrace');
    if (reportToCrashlytics) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: message,
        fatal: fatal,
      );
    }
  }

  void _print(String level, String message) {
    if (kDebugMode) debugPrint('[$level] [${DateTime.now()}] $message');
  }
}
