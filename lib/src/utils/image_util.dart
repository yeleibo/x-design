import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:x_design/src/widgets/xd_app.dart';
import 'dart:ui' as ui;
import 'package:x_design/src/utils/file_util.dart';

import '../widgets/image/image_view_dialog.dart';
import 'dart:io';
class XDImageUtil {
  ///给图片添加文字水印
  ///   var imageBytes=await rootBundle.load("assets/images/test.jpg");
  ///         var jpgImage= image_lib.decodeJpg(imageBytes.buffer.asUint8List());
  ///         var result=await XDImageUtil.addWatermarkText(sourceImage: jpgImage!, text: "测试",offset: Offset(100, 200),textStyle: TextStyle(color: Colors.redAccent));
  ///         XDImageUtil.viewImage(imageBytes: image_lib.encodePng(result));
  static Future<image_lib.Image> addWatermarkText(
      {
      ///初始图片
      required image_lib.Image sourceImage,
      ///水印内容
      TextStyle textStyle=const TextStyle(color: Colors.white, fontSize: 50.0),
        ///文字内容，多行额可以是'''内容1'''的形式
      required String text,
      ///文字在画布的位置
      Offset offset=const Offset(0, 0),

    }) async {

    var textImage =
        await textToImage(text: text, textStyle: textStyle);

    return image_lib.compositeImage(sourceImage, textImage,
        dstX:-(sourceImage.width*0.2).toInt(),
        dstY: (sourceImage.height*0.9).toInt(),
        blend: image_lib.BlendMode.alpha);
  }


  ///将文字转换成Image
  static Future<image_lib.Image> textToImage({

    required String text,
    TextStyle textStyle=const TextStyle(color: Colors.black, fontSize: 60.0),
    //文字位置
    Offset offset = const Offset(0, 0),
  }) async {
    // 创建一个PictureRecorder
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // 绘制文字
    // 创建 TextPainter
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
    );

    // 进行布局
    textPainter.layout();

    // 将文字绘制到画布上
    textPainter.paint(canvas, offset);

    // 将绘制的内容转换为图像
    final picture = recorder.endRecording();
    final uiImage = await picture.toImage(
        textPainter.width.toInt() + offset.dx.toInt(),
        textPainter.height.toInt() + offset.dy.toInt());

    // 将图像转换为Unit8List
    final ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    //转换成Image
    return image_lib.decodeImage(byteData!.buffer.asUint8List())!;
  }

  ///选择多张图片图片
  static Future<List<PlatformFile>?> pickImages(
      {required BuildContext context,
      bool multiple = false,
        bool pickFromCamera=true,
      List<String>? allowedExtensions}) {
    return XDFileUtil.pickFiles(
        multiple: multiple,
        pickFromCamera:pickFromCamera,
        fileType: FileType.image,
        allowedExtensions: allowedExtensions);
  }

  ///选择单张图片
  static Future<PlatformFile?> pickImage(
      {required BuildContext context, List<String>? allowedExtensions,    bool pickFromCamera=true}) {
    return pickImages(
        context: context,
        multiple: false,
        pickFromCamera:pickFromCamera,
        allowedExtensions: allowedExtensions).then((files) => files?.firstOrNull);
  }

  ///展示单张图片
  static void viewImage(
      {BuildContext? context,
      String? imagePath,
      Uint8List? imageBytes,
      String? imageName}) {
    assert(imagePath != null || imageBytes != null);
    showDialog(
        context: context ?? xdContext,
        builder: (_) {
          return ImageViewDialog(
            imageBytes: imageBytes == null ? null : [imageBytes],
            imageName: imageName,
            imagePath: imagePath == null ? null : [imagePath],
          );
        });
  }

  ///展示多张图片
  static void viewImages(
      {BuildContext? context,
      List<String>? imagePath,
      List<Uint8List>? imageBytes,
      String? imageName}) {
    assert(imagePath != null || imageBytes != null);
    showDialog(
        context: context ?? xdContext,
        builder: (_) {
          return ImageViewDialog(
            imageBytes: imageBytes,
            imageName: imageName,
            imagePath: imagePath,
          );
        });
  }

  // 转换 [CameraImage] 到 [image_lib.Image]
  static image_lib.Image? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      var image= convertYUV420ToImage(cameraImage);
      if (Platform.isAndroid) {
        image = image_lib.copyRotate(image, angle: 90);
      }
      return image;
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  // 转换  BGRA888 格式[CameraImage]  到 RGB格式[imageLib.Image]
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    image_lib.Image img = image_lib.Image.fromBytes(
        width: cameraImage.planes[0].width!,
        height: cameraImage.planes[0].height!,
        bytes: cameraImage.planes[0].bytes.buffer,
        order: image_lib.ChannelOrder.bgra);
    return img;
  }

  // 转换  YUV420 格式[CameraImage]  到 RGB格式[imageLib.Image]
  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }
    return image;
  }
}
