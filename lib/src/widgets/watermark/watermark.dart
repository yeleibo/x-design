import 'package:flutter/material.dart';
import 'dart:math';

class XDWatermark extends StatelessWidget {
  final Widget child;

  ///水印文字
  final String content;


  ///文字样式
  final TextStyle textStyle;

  ///水印偏移量
  final Offset offset;

  ///水印间隔
  final Offset gap;


  ///水印旋转角度
  final double rotate;


  XDWatermark(
      {super.key,
      required this.child,
      required this.content ,
        this.textStyle = const TextStyle(
          fontSize: 30,
          color: Color(0x7D9E9E9E),
        ),
        this.gap = const Offset(200, 200),
        this.rotate = 0,
        this.offset = const Offset(0, 0),
      });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: WatermarkPaint(
        content: content,
        textStyle: textStyle,
        offset: offset,
        gap: gap,
        angle: rotate
      ),
      child: child,
    );
  }
}

//绘制水印
class WatermarkPaint extends CustomPainter {
  final String content;
  final TextStyle textStyle;
  final Offset offset;
  final double angle;
  final Offset gap;
  WatermarkPaint(
      {required this.content, required this.textStyle,required this.offset,required this.gap,required this.angle});
  @override
  void paint(Canvas canvas, Size size) {


    var textPainter = TextPainter(
      text: TextSpan(
        text: content,
        style: textStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    // 计算每行文字的高度
    double lineHeight = textPainter.height;

     //每行多少个
    int maxCount = (size.width / (textPainter.width)).round();

    // 旋转角度
    double rotationAngle = angle * pi / 180;

    // 绘制每行文字
    for (int i = 0; i < (size.height / (gap.dy + lineHeight)).round(); i++) {
      double yOffset =  (i * (gap.dy + lineHeight)) + offset.dy ;
      for (int j = 0; j < maxCount; j++) {
        double xOffset = (j  * (textPainter.width + gap.dx)) + offset.dx ;
        canvas.save(); // 保存当前画布状态
        canvas.translate(xOffset, yOffset); // 平移至绘制位置
        canvas.rotate(rotationAngle); // 旋转画布
        textPainter.paint(canvas, Offset(0, 0)); // 绘制文本
        canvas.restore(); // 恢复画布状态
        // textPainter.paint(
        //     canvas,
        //     Offset(
        //         xOffset,
        //         yOffset));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
