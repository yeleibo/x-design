import 'package:flutter/material.dart';

///悬浮替代组件
class HoverReplaceWidget extends StatefulWidget {
  final double? width;
  final double? height;
  ///悬浮的组件
  final Widget child;
  ///悬浮的组件
  final Widget hoverChild;

  ///点击事件
  final GestureTapCallback? onTap;
  const HoverReplaceWidget(
      {Key? key, this.onTap, required this.hoverChild,required this.child, this.width, this.height})
      : super(key: key);

  @override
  State<HoverReplaceWidget> createState() => _HoverReplaceWidgetState();
}

class _HoverReplaceWidgetState extends State<HoverReplaceWidget> {
  late Widget child ;
  @override
  void initState() {
    super.initState();
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            child = widget.hoverChild;
          });
        },
        onExit: (event) {
          setState(() {
            child = const Icon(Icons.more_horiz);
          });
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: child,
        ),
      ),
    );
  }
}
