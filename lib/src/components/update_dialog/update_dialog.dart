import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_design/src/components/button/index.dart';

import 'number_progress.dart';

///版本更新加提示框
// class UpdateDialog {
//   bool _isShowing = false;
//   late BuildContext _context;
//   late UpdateWidget _widget;
//
//   UpdateDialog(BuildContext context,
//       {double width = 0.0,
//       required String title,
//       required String updateContent,
//       required VoidCallback onUpdate,
//       double titleTextSize = 16.0,
//       double contentTextSize = 14.0,
//       double buttonTextSize = 14.0,
//       double progress = -1.0,
//       Color progressBackgroundColor = const Color(0xFFFFCDD2),
//       Image? topImage,
//       double extraHeight = 5.0,
//       double radius = 4.0,
//       Color themeColor = Colors.red,
//       bool enableIgnore = false,
//       VoidCallback? onIgnore,
//       bool isForce = false,
//       String? updateButtonText,
//       String? ignoreButtonText,
//       VoidCallback? onClose}) {
//     _context = context;
//     _widget = UpdateWidget(
//         width: width,
//         title: title,
//         updateContent: updateContent,
//         onUpdate: onUpdate,
//         titleTextSize: titleTextSize,
//         contentTextSize: contentTextSize,
//         buttonTextSize: buttonTextSize,
//         progress: progress,
//         topImage: topImage,
//         extraHeight: extraHeight,
//         radius: radius,
//         themeColor: themeColor,
//         progressBackgroundColor: progressBackgroundColor,
//         enableIgnore: enableIgnore,
//         onIgnore: onIgnore,
//         isForce: isForce,
//         updateButtonText: updateButtonText ?? '更新',
//         ignoreButtonText: ignoreButtonText ?? '忽略此版本',
//         onClose: onClose ?? () => dismiss());
//   }
//
//   /// 显示弹窗
//   Future<bool> show() {
//     try {
//       if (isShowing()) {
//         return Future<bool>.value(false);
//       }
//       showDialog<bool>(
//           context: _context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return WillPopScope(
//                 onWillPop: () => Future<bool>.value(false), child: _widget);
//           });
//       _isShowing = true;
//       return Future<bool>.value(true);
//     } catch (err) {
//       _isShowing = false;
//       return Future<bool>.value(false);
//     }
//   }
//
//   /// 隐藏弹窗
//   Future<bool> dismiss() {
//     try {
//       if (_isShowing) {
//         _isShowing = false;
//         Navigator.pop(_context);
//         return Future<bool>.value(true);
//       } else {
//         return Future<bool>.value(false);
//       }
//     } catch (err) {
//       return Future<bool>.value(false);
//     }
//   }
//
//   /// 是否显示
//   bool isShowing() {
//     return _isShowing;
//   }
//
//   /// 更新进度
//   void update(double progress) {
//     if (isShowing()) {
//       _widget.update(progress);
//     }
//   }
//
//   /// 显示版本更新提示框
//   static UpdateDialog showUpdate(BuildContext context,
//       {double width = 0.0,
//       required String title,
//       required String updateContent,
//       required VoidCallback onUpdate,
//       double titleTextSize = 16.0,
//       double contentTextSize = 14.0,
//       double buttonTextSize = 14.0,
//       double progress = -1.0,
//       Color progressBackgroundColor = const Color(0xFFFFCDD2),
//       Image? topImage,
//       double extraHeight = 5.0,
//       double radius = 4.0,
//       Color themeColor = Colors.red,
//       bool enableIgnore = false,
//       VoidCallback? onIgnore,
//       String? updateButtonText,
//       String? ignoreButtonText,
//       bool isForce = false}) {
//     final UpdateDialog dialog = UpdateDialog(context,
//         width: width,
//         title: title,
//         updateContent: updateContent,
//         onUpdate: onUpdate,
//         titleTextSize: titleTextSize,
//         contentTextSize: contentTextSize,
//         buttonTextSize: buttonTextSize,
//         progress: progress,
//         topImage: topImage,
//         extraHeight: extraHeight,
//         radius: radius,
//         themeColor: themeColor,
//         progressBackgroundColor: progressBackgroundColor,
//         enableIgnore: enableIgnore,
//         isForce: isForce,
//         updateButtonText: updateButtonText,
//         ignoreButtonText: ignoreButtonText,
//         onIgnore: onIgnore);
//     dialog.show();
//     return dialog;
//   }
// }

// ignore: must_be_immutable

class UpdateWidget extends StatefulWidget {
  /// 对话框的宽度
  final double width;

  /// 升级标题
  final String title;

  /// 更新内容
  final String updateContent;

  /// 标题文字的大小
  final double titleTextSize;

  /// 更新文字内容的大小
  final double contentTextSize;

  /// 按钮文字的大小
  final double buttonTextSize;

  /// 顶部图片
  final Widget? topImage;

  /// 拓展高度(适配顶部图片高度不一致的情况）
  final double extraHeight;

  /// 边框圆角大小
  final double radius;

  /// 主题颜色
  final Color themeColor;

  /// 更新事件
  final VoidCallback onUpdate;

  ///手动更新
  final VoidCallback? onManualUpdate;

  /// 可忽略更新
  final bool enableIgnore;

  /// 更新事件
  final VoidCallback? onIgnore;

  double progress;

  /// 进度条的背景颜色
  final Color progressBackgroundColor;

  /// 更新事件
  final VoidCallback? onClose;

  /// 是否是强制更新
  final bool isForce;

  /// 更新按钮内容
  final String updateButtonText;

  /// 忽略按钮内容
  final String ignoreButtonText;

  UpdateWidget(
      {Key? key,
      this.width = 0.0,
      required this.title,
      required this.updateContent,
      required this.onUpdate,
      this.onManualUpdate,
      this.titleTextSize = 16.0,
      this.contentTextSize = 14.0,
      this.buttonTextSize = 14.0,
      this.progress = -1.0,
      this.progressBackgroundColor = const Color(0xFFFFCDD2),
      this.topImage,
      this.extraHeight = 5.0,
      this.radius = 4.0,
      this.themeColor = Colors.red,
      this.enableIgnore = false,
      this.onIgnore,
      this.isForce = false,
      this.updateButtonText = '更新',
      this.ignoreButtonText = '忽略此版本',
      this.onClose})
      : super(key: key);

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {

  @override
  Widget build(BuildContext context) {
    final double dialogWidth =
        widget.width <= 0 ? getFitWidth(context) * 0.7 : widget.width;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: dialogWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.radius),
                  topRight: Radius.circular(widget.radius),
                ),
                child: widget.topImage ??
                    Image.asset(
                      'assets/images/update_dialog.png',
                      package: 'x_design',
                      fit: BoxFit.cover,
                      width: dialogWidth,
                      height: dialogWidth * 0.4,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: widget.titleTextSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.updateContent,
                      style: TextStyle(
                        fontSize: widget.contentTextSize,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.onManualUpdate != null)
                      SizedBox(
                        height: 50,
                        child: XDButton(
                          type: ButtonType.text,
                          onClick: widget.onManualUpdate,
                          child: Text(
                            '手动更新',
                            style: TextStyle(
                              fontSize: widget.buttonTextSize,
                              color: widget.themeColor,
                            ),
                          ),
                        ),
                      ),
                    // const SizedBox(height: 16),
                    _buildActionButtons(),
                    // if (widget.progress < 0) _buildActionButtons() else _buildProgressBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 操作按钮
  Widget _buildActionButtons() {
    final buttons = <Widget>[];

    buttons.add(
      Expanded(
        child: XDButton(
          block: true,
          type: ButtonType.primary,
          shape: ButtonShape.stadium,
          color: widget.themeColor,
          onClick: widget.onUpdate,
          child: Text(widget.updateButtonText),
        ),
      ),
    );

    if (!widget.isForce) {
      bool enableIgnore = widget.enableIgnore && widget.onIgnore != null;
      buttons.add(const SizedBox(width: 10));
      buttons.add(
        Expanded(
          child: XDButton(
            block: true,
            type: ButtonType.primary,
            shape: ButtonShape.stadium,
            color: const Color(0xFFFFF8F8F8),
            onClick: enableIgnore ? widget.onIgnore : widget.onClose,
            child: Text(
              enableIgnore ? widget.ignoreButtonText : '以后再说',
              style: const TextStyle(
                color: Color(0xFFF333333),
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox(height: 40, child: Row(children: buttons));
  }

  // 下载进度条
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: NumberProgress(
        value: widget.progress,
        backgroundColor: widget.progressBackgroundColor,
        valueColor: widget.themeColor,
        height: 15.0,
        textSize: 12.0,
        textColor: Colors.black87,
      ),
    );
  }

  double getFitWidth(BuildContext context) {
    return min(getScreenHeight(context), getScreenWidth(context));
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
