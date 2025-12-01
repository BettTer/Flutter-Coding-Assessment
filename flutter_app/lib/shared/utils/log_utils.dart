import 'package:logger/logger.dart';

class Log {
  // 1. 初始化 Logger 实例
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // 打印日志时不显示调用堆栈的方法数（设为 0 会更清爽）
      errorMethodCount: 5, // 只有出错时才显示堆栈
      lineLength: 80, // 每行最大长度
      colors: true, // 开启多彩日志
      printEmojis: true, // 开启 Emoji (🚀, 🐛, 💡)
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 显示时间
    ),
  );

  // 2. 封装不同级别的日志

  /// Debug: 调试信息 (开发时看)
  static void d(String message) {
    _logger.d(message);
  }

  /// Info: 关键流程信息 (比如 "App启动", "开始登录")
  static void i(String message) {
    _logger.i(message);
  }

  /// Warning: 警告 (比如 "网络连接慢", "解析的数据缺少字段")
  static void w(String message) {
    _logger.w(message);
  }

  /// Error: 错误 (比如 "请求失败", "Catch 到异常")
  /// [error] 和 [stackTrace] 是可选参数，传进去可以打印堆栈
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
