/// Contract for app logging. Features depend on this, not on Crashlytics.
abstract class Logger {
  void info(String message);
  void warning(String message);
  void severe(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  });
}
