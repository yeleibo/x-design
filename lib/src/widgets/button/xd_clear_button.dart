import 'package:flutter/material.dart';

class XDClearButton extends StatelessWidget {
  final void Function() onTap;
  final double? size;
  const XDClearButton({Key? key, required this.onTap, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child:  Icon(
        Icons.cancel,
        size: size,
        color: Colors.blue,
      ),
    );
  }
}
