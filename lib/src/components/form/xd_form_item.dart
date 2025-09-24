import 'package:flutter/material.dart';

import '../../../xd_design.dart';

///表单item
///todo:将桌面端的给迁移过来
class XDFormItem extends StatelessWidget {
  final Widget label;
  final Widget child;
  final double childWidth;

  ///child是否填充剩余行空间
  final bool? childBlock;

  ///带冒号并且超过6个汉字需要大于136
  final double labelWidth;
  final Alignment labelAlignment;
  ///是否多行 label在上 child在下 mobile端使用
  final bool multiline;
  ///mobile端并且多行情况下 默认左居中
  final Alignment childAlignment;

  ///必填样式设置
  final bool required;
  const XDFormItem(
      {Key? key,
      required this.label,
      required this.child,
      this.childWidth = 200,
      this.labelWidth = 120,
      this.required = false,
      this.childAlignment = Alignment.centerLeft,
      this.labelAlignment = Alignment.centerLeft,
      this.childBlock,
      this.multiline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 20 : 3, horizontal: isDesktop ? 20 : 13),
      color: Colors.white,
      child: IntrinsicHeight(
          child: (isMobile && multiline)
              ? Column(
                  children: [
                    Container(
                      alignment: labelAlignment,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (required)
                            IconTheme(
                                data: IconThemeData(weight: 1, opticalSize: 2),
                                child: Icon(
                                  XDIcons.formFieldRequired,
                                  color: Colors.red,
                                  size: 20,
                                )),
                          label,
                        ],
                      ),
                    ),
                    Align(alignment: childAlignment, child: child)
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: labelAlignment,
                      width: labelWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (required)
                            IconTheme(
                                data: IconThemeData(weight: 1, opticalSize: 2),
                                child: Icon(
                                  XDIcons.formFieldRequired,
                                  color: Colors.red,
                                  size: 20,
                                )),
                          label,
                        ],
                      ),
                    ),
                    (childBlock ?? isMobile)
                        ? Expanded(child: child)
                        : Container(
                            alignment: Alignment.centerLeft,
                            width: childWidth,
                            child: child),
                  ],
                )),
    );
  }
}
