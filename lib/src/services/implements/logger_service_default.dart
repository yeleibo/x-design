import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../logger_service.dart';

class XDLoggerServiceDefault extends LoggerService {
  final Logger _client =
      Logger(printer: PrefixPrinter(PrettyPrinter(colors: true)));
  @mustCallSuper
  @override
  void d(message, {error, StackTrace? stackTrace}) {
    _client.log(
      Level.debug,
      message,
      error:error,
      stackTrace:stackTrace,
    );
  }

  @mustCallSuper
  @override
  void e({error, StackTrace? stackTrace}) {
    if (error is Error) {
      stackTrace = error.stackTrace;
    }
    assert(() {
      _client.log(
        Level.error,
        "app出现异常",
        error:error,
        stackTrace:stackTrace,
      );
      return true;
    }());
    //todo:错误日志上传到日志服务器,
    //
    // FlutterBugly.uploadException(
    //     message: error.toString(), detail: stackTrace.toString(), data: data);
  }

  @mustCallSuper
  @override
  void i(message, {error, StackTrace? stackTrace}) {
    _client.log(
      Level.info,
      message,
      error:error,
      stackTrace:stackTrace,
    );
  }

  @mustCallSuper
  @override
  void w(message, {error, StackTrace? stackTrace}) {
    _client.log(
      Level.warning,
      message,
      error:error,
      stackTrace:stackTrace,
    );
  }
}
