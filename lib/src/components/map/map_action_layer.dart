import 'package:flutter/material.dart';

///地图操作的基础组件
class XDMapActionLayer extends StatelessWidget {
  final Widget? text;
  final GestureTapCallback? onTap;
  final Widget iconWidget;
  const XDMapActionLayer(
      {super.key, this.text, required this.iconWidget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(
              //     width: 2, color: Colors.blue)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconWidget,
                if (text != null)
                  DefaultTextStyle(
                      style: TextStyle(fontSize: 10.0, color: Colors.black),
                      child: text!),
              ],
            )));
  }
}
