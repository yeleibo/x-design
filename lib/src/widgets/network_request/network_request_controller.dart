import 'package:flutter/cupertino.dart';

import '../../../xd_design.dart';
///网络请求控制器
class XDNetworkRequestController<T> extends ChangeNotifier{
  ///获取数据的方法
  final  Future<T> Function() fetchDataFunction;
  ///初始值
  final T? initialValue;
   NetworkRequestStatus? networkState;
  ///返回的数据
  T? data;
  XDNetworkRequestController({required this.fetchDataFunction,this.initialValue}):data=initialValue;

  ///获取数据
  Future<void> fetchData() async {
    networkState=NetworkRequestStatus.requesting;
    notifyListeners();
    try{
      data= await fetchDataFunction();
      networkState=NetworkRequestStatus.requestSuccess;
    }catch(ex){
      loggerService.e(error: ex);
      networkState=NetworkRequestStatus.requestFail;
    }finally{
      notifyListeners();
    }


  }

}