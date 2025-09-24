import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:x_design/xd_design.dart';


///Dio的请求日志拦截器
class XDDioLoggerInterceptor extends Interceptor {
  final LoggerService loggerService;

  XDDioLoggerInterceptor(this.loggerService);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    // await Future.delayed(Duration(seconds: 3));
    loggerService.i({
      '网络请求日志': '网络请求信息：${options.baseUrl}${options.path}',
      '请求方式': options.headers.toString(),

      '请求数据': options.method == "GET"
          ? options.queryParameters.toString()
          : options.data.toString(),
    });
    return super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(response.requestOptions.contentType==Headers.jsonContentType){
      loggerService.i({
        '网络响应日志': '网络响应信息：${response.requestOptions.uri}',
        '请求方式':response.requestOptions.method,
        '请求数据':  jsonEncode(response.requestOptions.data),
        '响应数据': jsonEncode(response.data)
      });
    }

    return super.onResponse(response, handler);
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    loggerService.i({
      '网络请求日志':
      '网络请求出错：${err.requestOptions.baseUrl}${err.requestOptions.path}',
      '错误信息：': '${err.message},${err.stackTrace}',
      '请求头': err.requestOptions.headers.toString(),
      '请求数据': err.requestOptions.method == "GET"
          ? err.requestOptions.queryParameters
          : err.requestOptions.data.toString(),
      '请求方式': err.requestOptions.method,
      '响应数据': err.response?.data
    },error: err, stackTrace: err.stackTrace);
    return super.onError(err, handler);
  }
}
