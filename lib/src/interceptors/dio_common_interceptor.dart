import 'dart:convert';

import 'package:dio/dio.dart';

///dio自定义的拦截器，对返回的数据进行统一处理后返回给应用,统一处理认证相关的处理和对网络请求异常的处理
class XDDioCommonInterceptor extends Interceptor {

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //对向总那边的网络请求返回的字符串做序列化处理
    if(response.requestOptions.path.contains("postType")){
      var responseData=jsonDecode(response.data);
      if(responseData is Map && (responseData['error']!=null&&responseData['code']!=200)){
        throw DioException( requestOptions: response.requestOptions,message: responseData['error']);
      }else{
        response.data=responseData;
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(err, handler) {
    String errorMessage = "network error";

    if (err.response?.data != null) {
      if (err.response!.data['detail'] != null) {
        errorMessage = err.response!.data['detail'];
      }
    }else{
      switch(err.type){
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.connectionError:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage="network connect error";
        default:
          errorMessage = "network error";
      }
    }

    super.onError(err.copyWith(message: errorMessage), handler);
  }
}
