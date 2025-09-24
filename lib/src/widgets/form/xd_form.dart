import 'package:flutter/material.dart';

import '../../../xd_design.dart';

class XDForm extends StatelessWidget {
  final List<Widget> children;

  ///操作组件
  final Widget? footer;
  const XDForm({Key? key, required this.children, this.footer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isDesktop) {
      child = Wrap(
          crossAxisAlignment: WrapCrossAlignment.center, children: children);
    } else {
      child = Container(
        color: Colors.grey.shade200,
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: children,
            )),
            if (footer != null) footer!
          ],
        ),
      );
    }
    return Form(child: child);
  }
}
