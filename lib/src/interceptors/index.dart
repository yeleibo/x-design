import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:x_design/src/interceptors/dio_logger_interceptor.dart';

import '../services/index.dart';
import 'dio_common_interceptor.dart';
import 'dio_token_interceptor.dart';

export 'dio_logger_interceptor.dart';
export 'dio_common_interceptor.dart';
export 'dio_token_interceptor.dart';

List<Interceptor> getXDDioInterceptors({String Function(RequestOptions options)? getToken})=>[
  if(kDebugMode)
    XDDioLoggerInterceptor(loggerService),
  XDDioCommonInterceptor(),
  if(getToken!=null)
  XDDioTokenInterceptor(getToken),

];