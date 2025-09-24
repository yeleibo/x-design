import 'package:get_it/get_it.dart';

var loggerService=GetIt.I<LoggerService>();

///日志相关服务
abstract class LoggerService {
  /// info level logs
  void i(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  });

  /// warning level logs
  void w(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  });

  /// debug level logs
  void d(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  });

  /// Error level logs
  void e(
      {
        dynamic error,
        StackTrace? stackTrace,
      });

}
