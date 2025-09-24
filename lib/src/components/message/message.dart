import 'dart:async';

import 'package:flutter/material.dart';

import '../xd_app.dart';
import 'message_overlay_entry.dart';

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
  ///单例模式
  Message._internal();
  factory Message() => _instance;
  static final Message _instance = Message._internal();

  final List<OverlayEntry> _overlayEntries = [];

  Future<void> info(
      {required String content,
      BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {


    _showOverlayEntry(
        context,
        MessageWidget(
          message: content,
          icon: Icon(
            Icons.info_rounded,
            color: Theme.of(context ??  xdNavigatorKey.currentContext!).primaryColor,
          ),
        ),
        duration,
        onClose);
  }

  Future<void> success(
      {required String content,
      BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {

    _showOverlayEntry(
        context,
        MessageWidget(
          message: content,
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
          ),
        ),
        duration,
        onClose);
  }

  Future<void> warning(
      {required String content,
        BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {
    _showOverlayEntry(
        context,
        MessageWidget(
          message: content,
          icon: const Icon(
            Icons.error_outlined,
            color: Colors.orange,
          ),
        ),
        duration,
        onClose);
  }

  Future<void> error(
      {required String content,
        BuildContext? context,
      Duration duration = _messageDefaultDuration,
      Function? onClose}) async {
    _showOverlayEntry(
        context,
        MessageWidget(
          message: content,
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
        duration,
        onClose);
  }

  Future<void> loading(
      {required String content,
        BuildContext? context,
      Duration duration =_messageDefaultDuration,
      Function? onClose}) async {
    _showOverlayEntry(
        context,
        MessageWidget(
          message: content,
          icon: Container(padding: EdgeInsets.all(2),width: 20,height: 20,child: CircularProgressIndicator(strokeWidth:2),),
        ),
        duration,
        onClose);
  }

  Future<void> destroy({Key? key}) async {
    for (var overlayEntry in _overlayEntries) {
      if(overlayEntry.mounted){
        overlayEntry.remove();
      }
    }
    _overlayEntries.clear();
  }



  void _showOverlayEntry(BuildContext? context, Widget messageWidget,
      Duration duration, Function? onClose) {
    var overlayState =context!=null? Overlay.of(context):xdNavigatorKey.currentState!.overlay!;

    var overlayEntry =
        OverlayEntry(builder: (BuildContext context) => messageWidget);

    overlayState.insert(overlayEntry);
    _overlayEntries.add(overlayEntry);

    Timer(duration, () {
      if(overlayEntry.mounted){
        overlayEntry.remove();
        _overlayEntries.remove(overlayEntry);
      }

      onClose?.call();
    });
  }
}

