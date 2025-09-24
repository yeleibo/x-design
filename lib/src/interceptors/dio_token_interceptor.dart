import 'package:dio/dio.dart';

///Dio的请求日志拦截器
class XDDioTokenInterceptor extends Interceptor {
  final String Function(RequestOptions options) getToken;
  XDDioTokenInterceptor(this.getToken);
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    var token=getToken.call(options);
      if (token.isNotEmpty) {
        options.headers['Authorization'] =
        'Bearer ${token}';
      }
    super.onRequest(options, handler);
  }
}