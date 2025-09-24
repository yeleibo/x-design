import 'package:flutter/material.dart';

import '../../../xd_design.dart';

///通用的Footer
class XDFooterCommon extends StatelessWidget {
  final List<Widget> actions;
  const XDFooterCommon({Key? key, required this.actions}) : super(key: key);

  XDFooterCommon.withSubmit(
      {super.key, VoidCallback? onSubmit, String text = '提交'})
      : actions = [
          XDButton(
            child: Text(text),
            onClick: onSubmit,
            block: true,
            type: ButtonType.primary,
          )
        ];

  @override
  Widget build(BuildContext context) {
    if(actions.isEmpty)return SizedBox();
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 阴影颜色
            spreadRadius: 5, // 阴影扩散的范围
            blurRadius: 7, // 阴影的模糊程度
            offset: Offset(0, 3), // 阴影的偏移量
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
      height: 65,
      child: Row(
        children: actions
            .map((e) => Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: e,
                )))
            .toList(),
      ),
    );
  }
}
