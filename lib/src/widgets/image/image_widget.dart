import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/image_util.dart';

///图片组件
class XDImageWidget extends StatelessWidget {
  final String? imagePath;
  final Uint8List? imageBytes;
  final Widget? imageNotExistWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isRadius;
  final Alignment alignment;
  final double radiusNum;
  final String? package;
  ///是否可以放大查看
  final bool enableEnlargeView;
  ///SVG颜色
  final Color? color;

  const XDImageWidget(
      {Key? key,
      this.imagePath,
      this.imageBytes,
      this.height,
      this.width,
      this.fit,
      this.imageNotExistWidget,
      this.isRadius = true,
      this.radiusNum = 4.0,
        this.alignment=Alignment.center,
      this.package,this.enableEnlargeView=false,
      this.color})
      : assert(imagePath != null || imageBytes != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox();

    // 检查是否为SVG文件
    if (imagePath != null && isSvgImage(imagePath!)) {
      if (isNetWorkImg(imagePath!)) {
        image = SvgPicture.network(
          imagePath!,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          alignment: alignment,
        );
      } else if (isAssetsImg(imagePath!)) {
        image = SvgPicture.asset(
          imagePath!,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          alignment: alignment,
          package: package,
        );
      } else if (File(imagePath!).existsSync()) {
        image = SvgPicture.file(
          File(imagePath!),
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          alignment: alignment,
        );
      } else {
        image = imageNotExistWidget != null
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.black26.withOpacity(0.1),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2), width: 0.3)),
                child: Image.asset(
                  'assets/image_not_exit.png',
                  alignment: alignment,
                  width: width,
                  height: height,
                  fit: fit,
                ),
              )
            : imageNotExistWidget??SizedBox();
      }
    } else if (imageBytes != null) {
      image = Image.memory(
        alignment: alignment,
        imageBytes!,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      if (imagePath != null) {
        if (isNetWorkImg(imagePath!)) {
          image = Image.network(
            imagePath!,
            loadingBuilder: (
                context,
                child,
                loadingProgress,
                ) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ));
            },
            errorBuilder: (context, error, stackTrace) {
              return Text("文件获取出错");
            },
            width: width,
            height: height,
            fit: fit,
          );
          // 处理证书不安全的图片获取问题
          // if(isHttpsUrl(imagePath!)) {
          //   image =  FutureBuilder(
          //     future: fetchImageBytes(imagePath!),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasData) {
          //           return Image.memory(
          //             snapshot.data!,
          //             alignment: alignment,
          //             width: width,
          //             height: height,
          //             fit: fit,
          //           );
          //         } else {
          //           return imageNotExistWidget ??
          //               const SizedBox(); // 返回默认的占位图
          //         }
          //       } else {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //     },
          //   );
          // }else{
          //   image = Image.network(
          //     imagePath!,
          //     loadingBuilder: (
          //         context,
          //         child,
          //         loadingProgress,
          //         ) {
          //       if (loadingProgress == null) {
          //         return child;
          //       }
          //       return Center(
          //           child: CircularProgressIndicator(
          //             value: loadingProgress.expectedTotalBytes != null
          //                 ? loadingProgress.cumulativeBytesLoaded /
          //                 loadingProgress.expectedTotalBytes!
          //                 : null,
          //           ));
          //     },
          //     errorBuilder: (context, error, stackTrace) {
          //       return Text("文件获取出错");
          //     },
          //     width: width,
          //     height: height,
          //     fit: fit,
          //   );
          // }
        } else if (isAssetsImg(imagePath!)) {
          image = Image.asset(
            imagePath!,
            alignment: alignment,
            width: width,
            height: height,
            fit: fit,
            package: package,
          );
        } else if (File(imagePath!).existsSync()) {
          image = Image.file(
            File(imagePath!),
            alignment: alignment,
            width: width,
            height: height,
            fit: fit,
          );
        } else {
          image = imageNotExistWidget != null
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.black26.withOpacity(0.1),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 0.3)),
                  child: Image.asset(
                    'assets/image_not_exit.png',
                    alignment: alignment,
                    width: width,
                    height: height,
                    fit: fit,
                  ),
                )
              : imageNotExistWidget??SizedBox();
        }
      }
    }

    if (isRadius) {
      image= ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(radiusNum),
        ),
        child: image,
      );
    }
    if(enableEnlargeView){
      image=GestureDetector(onTap: (){
        String? imageName;
        if(imagePath!=null){
          final match = RegExp(r'\[(.*?)\]').firstMatch(imagePath!);
          var name  = match?.group(1);
          if(name!=null){
            var r =name.split('.');
            if (r.length < 2){
              imageName = name;
            }else{
              imageName = r.sublist(0, r.length - 1).join('.');
            }
          }
        }
        XDImageUtil.viewImage(context: context,imageBytes: imageBytes,imagePath: imagePath,imageName: imageName);
      },child: image,);
    }
    return image;
  }


  /// 判断是否网络
  bool isNetWorkImg(String img) {
    return img.startsWith('http') || img.startsWith('https');
  }

  /// 判断是否资源图片
  bool isAssetsImg(String img) {
    return img.startsWith('asset') || img.startsWith('assets');
  }

  /// 判断是否SVG图片
  bool isSvgImage(String img) {
    return img.toLowerCase().endsWith('.svg');
  }
}

// 网络请求获取
Future<Uint8List> fetchImageBytes(String url) async {
  HttpClient client = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();

  if (response.statusCode == 200) {
    return await consolidateHttpClientResponseBytes(response);
  } else {
    throw Exception('Failed to load image');
  }
}

bool isHttpsUrl(String url) {
  final httpsRegex = RegExp(r'^https:\/\/', caseSensitive: false);
  return httpsRegex.hasMatch(url);
}




