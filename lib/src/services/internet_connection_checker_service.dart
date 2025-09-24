
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

var internetConnectionCheckerService=GetIt.instance<InternetConnectionCheckerService>();
class InternetConnectionCheckerService{
  InternetConnection? connection;
  bool hasInternetConnection = false;
  StreamSubscription? _listener ;
  InternetConnectionCheckerService([List<String>? urls]){
    urls??=["https://www.apple.com"];
    connection = InternetConnection.createInstance(
        customCheckOptions:urls.map((e)=>
            InternetCheckOption(uri: Uri.parse(e))
        ).toList());
    _listener= connection?.onStatusChange.listen((status) {
      hasInternetConnection = status == InternetStatus.connected;
    });
  }

  void dispose(){
    _listener?.cancel();
  }

}