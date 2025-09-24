import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageWidget extends StatefulWidget {
  final String message;
  final Widget? icon;
  const MessageWidget({Key? key, required this.message,  this.icon})
      : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 75,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
                constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(0, 2))
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
                  child: Row(mainAxisSize: MainAxisSize.min,children: [
                    widget.icon??const SizedBox(),
                    const SizedBox(width: 10,),
                    Flexible(
                      child: Text(
                        widget.message,
                      ),
                    ),
                  ],),
                )),
          ),
        ));
  }
}
