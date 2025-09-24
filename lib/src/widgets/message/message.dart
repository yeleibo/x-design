import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_design/src/widgets/xd_app.dart';

///默认使用的时[MaterialApp]提供了一个默认的[Overlay],弹窗位置是相对与[Overlay]来的
///可以在组件外面包裹一个[Overlay]组件,然后在[Overlay]组件里面使用[OverlayEntry]来实现弹窗
///eg:
///Container(
///               color: Colors.red,
///              width: 200,
///               height: 200,
///               child: Overlay(
///                 initialEntries: [
///                   OverlayEntry(builder: (context1) {
///                     return ElevatedButton(
///                       onPressed: () {
///                         message.info(content: "测试弹窗", context: context1);
///                       },
///                       child: Text("弹窗"),
///                     );
///                   })
///                 ],
///               ),
///             )
///
///如果调用时传了context会根据传入的context上的Overlay组件上添加，否则会采用全局的(MaterialApp提供的Overlay，前提是MaterialApp初始化时需要将navigatorKey设置为xdNavigatorKey)上添加
Message message = Message();

///默认展示时间,默认3秒钟
const Duration _messageDefaultDuration = Duration(milliseconds: 3000);
///通过navigator的context作为全局context,调用具体的弹窗可以使用具体的context
class Message {
  // final _fToast = FToast();

  ///单例模式
  Message._internal(){
    // _fToast.init(xdContext);
  }
  factory Message() => _instance;
  static final Message _instance = Message._internal();


  Future<void> info(
      {required String content,
      BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {

    Fluttertoast.showToast(msg: content,gravity: ToastGravity.CENTER);
  }

  Future<void> success(
      {required String content,
      BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {
    Fluttertoast.showToast(msg: content,gravity: ToastGravity.CENTER);
  }

  Future<void> warning(
      {required String content,
        BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {
    Fluttertoast.showToast(msg: content,gravity: ToastGravity.CENTER);
  }

  Future<void> error(
      {required String content,
        BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {
    Fluttertoast.showToast(msg: content,gravity: ToastGravity.CENTER);
  }

  Future<void> loading(
      {required String content,
        BuildContext? context,
      Duration duration =_messageDefaultDuration,
      Function? onClose}) async {

  }

  Future<void> destroy({Key? key}) async {
    Fluttertoast.cancel();
  }


}

