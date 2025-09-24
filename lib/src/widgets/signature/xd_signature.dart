import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:x_design/xd_design.dart';

class XDSignature extends StatefulWidget {
  /// 签名完成回调
  final Function(Uint8List? signature)? onSignatureSubmit;
  /// 签名画板宽度
  final double width;
  /// 签名画板高度
  final double height;
  /// 签名画板背景色
  final Color backgroundColor;
  /// 签名画笔颜色
  final Color penColor;
  /// 签名画笔宽度
  final double penStrokeWidth;
  /// 导出图片背景色
  final Color exportBackgroundColor;
  /// 导出图片画笔颜色
  final Color exportPenColor;
  ///导出图片高度
   final int exportHeight;
  ///导出图片宽度
    final int exportWidth;
  const XDSignature(
      {super.key,
        this.onSignatureSubmit,
        this.width = 600,
        this.height = 300,
        this.backgroundColor = const Color(0xFFF5F5F5),
        this.penColor = Colors.red,
        this.penStrokeWidth = 3,
        this.exportBackgroundColor = const Color(0xFFF5F5F5),
        this.exportPenColor = Colors.black,
        this.exportHeight=500,
        this.exportWidth=1000,
      });

  @override
  State<XDSignature> createState() => _XDSignatureState();
}

class _XDSignatureState extends State<XDSignature> {
  // initialize the signature controller
  late SignatureController controller;

  @override
  void initState() {
    super.initState();
    controller = SignatureController(
      penStrokeWidth: widget.penStrokeWidth,
      penColor: widget.penColor,
      exportBackgroundColor: widget.exportBackgroundColor,
      exportPenColor: widget.exportPenColor,
    );
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Signature(
              controller: controller,
              height: widget.height,
              width: widget.width,
              backgroundColor: widget.backgroundColor,
            ),
          ),
          const Divider(),
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  XDButton(
                    color: Colors.red,
                    child: const Text('清空'),
                    onClick: () {
                      setState(() => controller.clear());
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  XDButton(
                    color: Colors.blue,
                    child: const Text('确定'),
                    onClick: () async {
                      final Uint8List? signature = await controller
                          .toPngBytes(height: widget.exportHeight, width: widget.exportWidth);
                      widget.onSignatureSubmit?.call(signature);
                    },
                  ),
                ],
              ))
        ]);
  }
}
