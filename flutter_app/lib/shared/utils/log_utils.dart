import 'package:logger/logger.dart';

class Log {
  // 1.
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true, // (🚀, 🐛, 💡)
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // 2.

  /// Debug:
  static void d(String message) {
    _logger.d(message);
  }

  /// Info
  static void i(String message) {
    _logger.i(message);
  }

  /// Warning
  static void w(String message) {
    _logger.w(message);
  }

  /// Error, can sent [error] & [stackTrace]
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
