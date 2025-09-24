import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../xd_design.dart';

///图片查看弹窗
class ImageViewDialog extends StatefulWidget {
  final List<String>? imagePath;
  final List<Uint8List>? imageBytes;
  final String? imageName;
  const ImageViewDialog(
      {super.key, this.imagePath, this.imageBytes, this.imageName});

  @override
  State<ImageViewDialog> createState() => _ImageViewDialogState();
}

class _ImageViewDialogState extends State<ImageViewDialog> {
  String? currentImagePath;
  Uint8List? currentImageByte;
  Color? leftButtonColor;
  Color? rightButtonColor;
  double rotationAngle = 0.0;
  bool isFlippedHorizontally = false;
  bool isFlippedVertically = false;
  Size? imageSize;
  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      currentImagePath = widget.imagePath!.first;
    }

    if (widget.imageBytes != null) {
      currentImageByte = widget.imageBytes!.first;
    }
  }

  TransformationController controller = TransformationController();
  @override
  Widget build(BuildContext context) {
    if (widget.imagePath != null) {
      leftButtonColor = currentImagePath == widget.imagePath!.first
          ? Colors.grey
          : Colors.white;
      rightButtonColor = currentImagePath == widget.imagePath!.last
          ? Colors.grey
          : Colors.white;
    }
    if (widget.imageBytes != null) {
      leftButtonColor = currentImageByte == widget.imageBytes!.first
          ? Colors.grey
          : Colors.white;
      rightButtonColor = currentImageByte == widget.imageBytes!.last
          ? Colors.grey
          : Colors.white;
    }
    return Dialog(
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
          : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isMobile
                ? AppBar(
                    centerTitle: true,
                    title: Text(widget.imageName ?? '文件查看'),
                  )
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: isMobile ? 3 : 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            )),
                      ],
                    )),
            Expanded(
                child: Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isDesktop &&
                      (widget.imagePath != null || widget.imageBytes != null))
                    GestureDetector(
                      onTap: () {
                        if (widget.imagePath != null) {
                          setState(() {
                            int index =
                                widget.imagePath!.indexOf(currentImagePath!);
                            if (currentImagePath == widget.imagePath!.first) {
                              return;
                            }
                            currentImagePath = widget.imagePath![index - 1];
                          });
                        }
                        if (widget.imageBytes != null) {
                          setState(() {
                            int index =
                                widget.imageBytes!.indexOf(currentImageByte!);
                            if (currentImageByte == widget.imageBytes!.first) {
                              return;
                            }
                            currentImageByte = widget.imageBytes![index - 1];
                          });
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(100),
                          color: leftButtonColor,
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  Expanded(
                    child: InteractiveViewer(
                      // alignment: Alignment.center,
                      transformationController: controller,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.1,
                      maxScale: 10,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          imageSize =
                              Size(constraints.maxWidth, constraints.maxHeight);
                          return XDImageWidget(
                            width: constraints.maxWidth,
                            imagePath: currentImagePath,
                            imageBytes: currentImageByte,
                          );
                        },
                      ),
                    ),
                  ),
                  if (isDesktop &&
                      (widget.imagePath != null || widget.imageBytes != null))
                    GestureDetector(
                      onTap: () {
                        if (widget.imagePath != null) {
                          setState(() {
                            int index =
                                widget.imagePath!.indexOf(currentImagePath!);
                            if (currentImagePath == widget.imagePath!.last) {
                              return;
                            }
                            currentImagePath = widget.imagePath![index + 1];
                          });
                        }

                        if (widget.imageBytes != null) {
                          setState(() {
                            int index =
                                widget.imageBytes!.indexOf(currentImageByte!);
                            if (currentImageByte == widget.imageBytes!.last) {
                              return;
                            }
                            currentImageByte = widget.imageBytes![index + 1];
                          });
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(100),
                          color: rightButtonColor,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            )),
            Container(
                color: Colors.white,
                padding: EdgeInsets.all(isMobile ? 0 : 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // XDButton(
                    //   onClick: () {
                    //     setState(() {
                    //       rotationAngle -= 90 * (3.141592653589793 / 180);
                    //       var matrix=  Matrix4.identity()
                    //         ..translate(imageSize!.width/2, imageSize!.height/2)
                    //         ..rotateZ(rotationAngle)
                    //
                    //         ..translate(-imageSize!.width/2, -imageSize!.height/2);
                    //       controller.value =matrix;
                    //     });
                    //   },
                    //   child: Icon(Icons.rotate_90_degrees_ccw_outlined),
                    // ),
                    XDButton(
                      onClick: () {
                        setState(() {
                          rotationAngle += 90 * (3.141592653589793 / 180);
                          var matrix = Matrix4.identity()
                            ..translate(
                                imageSize!.width / 2, imageSize!.height / 2)
                            ..rotateZ(rotationAngle)
                            ..translate(
                                -imageSize!.width / 2, -imageSize!.height / 2);
                          controller.value = matrix;
                        });
                      },
                      child: Text(XDLocalizations.of(context).rotate),
                    ),
                    XDButton(
                      onClick: () {
                        setState(() {
                          controller.value = Matrix4.identity();
                        });
                      },
                      child: Text(XDLocalizations.of(context).reset),
                    ),
                    XDButton(
                      onClick: () {
                        setState(() {
                          var matrix = Matrix4.identity()
                            ..translate(
                                imageSize!.width / 2, imageSize!.height / 2)
                            ..scale(0.8)
                            ..translate(
                                -imageSize!.width / 2, -imageSize!.height / 2);
                          controller.value *= matrix;
                        });
                      },
                      child: Text(XDLocalizations.of(context).zoomOut),
                    ),
                    XDButton(
                      onClick: () {
                        setState(() {
                          var matrix = Matrix4.identity()
                            ..translate(
                                imageSize!.width / 2, imageSize!.height / 2)
                            ..scale(1.2)
                            ..translate(
                                -imageSize!.width / 2, -imageSize!.height / 2);
                          controller.value *= matrix;
                        });
                      },
                      child: Text(XDLocalizations.of(context).zoomIn),
                    ),
                    // XDButton(
                    //   onClick: () {
                    //     setState(() {
                    //       isFlippedHorizontally = !isFlippedHorizontally;
                    //     });
                    //     controller.value = Matrix4.diagonal3Values(isFlippedHorizontally ? -1 : 1, 1, 1);
                    //   },
                    //   child: Text('水平'),
                    // ),
                    // XDButton(
                    //   onClick: () {
                    //     setState(() {
                    //       isFlippedVertically = !isFlippedVertically;
                    //     });
                    //     controller.value = Matrix4.diagonal3Values(1, isFlippedVertically ? -1 : 1, 1);
                    //   },
                    //   child: Text('垂直'),
                    // ),
                  ],
                )),
          ]),
    );
  }
}
