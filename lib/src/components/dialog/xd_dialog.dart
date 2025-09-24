import 'package:flutter/material.dart';
import 'package:x_design/src/components/button/index.dart';

import '../../../xd_design.dart';

///XD弹窗组件
class XDDialog extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final List<Widget>? actions;
  final MainAxisAlignment actionsAlignment;

  ///这个可以设置弹窗的位置左上角是Alignment(-1,-1),右下角是Alignment(1,1)
  final AlignmentGeometry? alignment;

  ///是否全屏
  final bool fullScreen;
  const XDDialog(
      {Key? key,
      this.title,
      required this.child,
      this.actions,
      this.actionsAlignment = MainAxisAlignment.spaceBetween,
      this.alignment,
      this.fullScreen = true})
      : super(key: key);

  ///带有提交和取消按钮的可关闭弹窗
  XDDialog.withSubmitAndCancel(
      {super.key,
      this.title,
      required this.child,
      List<Widget>? actions,
      this.actionsAlignment = MainAxisAlignment.spaceBetween,
      required Function() onSubmit,
      required Function() onCancel,
      String? submitText,
      String? cancelText,
      Color? submitButtonColor,
      this.fullScreen = true,
      this.alignment})
      : actions = [
          ...?actions,
          XDButton(
            type: ButtonType.text,
            onClick: () {
              onCancel.call();
            },
            child: Text(cancelText ?? XDLocalizations.of(xdContext).cancel),
          ),
          XDButton(
            type: ButtonType.text,
            color: submitButtonColor,
            onClick: onSubmit,
            child: Text(submitText ?? XDLocalizations.of(xdContext).confirm),
          ),
        ];
  @override
  Widget build(BuildContext context) {
    var content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Container(
          //     padding: EdgeInsets.symmetric(
          //         horizontal: 20, vertical: isMobile ? 3 : 10),
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          //       color: Color(0xFFDAE9F8),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         title != null
          //             ? DefaultTextStyle.merge(
          //                 style: Theme.of(context).textTheme.titleMedium,
          //                 child: title!)
          //             : const SizedBox(),
          //         GestureDetector(
          //             onTap: () {
          //               Navigator.of(context).pop();
          //             },
          //             child: Icon(
          //               Icons.close,
          //               color: Colors.grey.shade500,
          //             )),
          //       ],
          //     )),
          fullScreen ? Expanded(child: child) : Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
            child: child,
          ),
          if (actions != null) ...[
            Divider(
              color: Colors.grey.shade300,
            ),
            Container(
                padding: EdgeInsets.all(isMobile ? 0 : 10),
                height: 48,
                child: Row(
                  mainAxisAlignment: actionsAlignment,
                  children: actions!
                      .map((e) => Expanded(
                        child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: e,
                            ),
                      ))
                      .toList(),
                ))
          ],
        ]);
    return Dialog(
        alignment: alignment,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 设置圆角
        ),
        child: fullScreen
            ? content
            : IntrinsicWidth(
                child: content,
              ));
  }
}

///弹出删除确定窗
Future<T?> showXDDeleteConfirmDialog<T>(
    {required BuildContext context, Function()? onDelete, String? title}) {
  return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(title ?? '确定删除吗？'),
          actions: [
            XDButton(
              child: Text(XDLocalizations.of(context).cancel),
              onClick: () {
                Navigator.of(context).pop();
              },
            ),
            XDButton(
              type: ButtonType.primary,
              color: Colors.redAccent,
              onClick: () async {
                await onDelete?.call();
                Navigator.of(context).pop(true);
              },
              child: Text(XDLocalizations.of(xdContext).delete),
            )
          ],
        );
      });
}
