import 'dart:async';

import 'package:flutter/material.dart';

import '../../../xd_design.dart';
import 'type.dart';

///按钮,
class XDButton extends StatefulWidget {
  ///背景颜色
  final Color? color;

  ///子组件
  final Widget? child;

  ///将按钮宽度调整为其父宽度的选项,false(默认)-》根据child大小来确定大小，true->填充整个父组件
  final bool block;

  ///按钮失效状态
  final bool disabled;

  ///设置按钮的图标组件 small->16 medium->18 large->20
  final Widget? icon;

  ///设置按钮形状
  final ButtonShape shape;

  ///设置按钮是否无边框,默认false
  final bool borderless;

  ///设置按钮大小
  final ButtonSize size;

  ///设置按钮类型
  final ButtonType type;

  ///点击事件
  final FutureOr Function()? onClick;
  ///是否加载中
  final bool isLoading;
  final EdgeInsets? padding;
  const XDButton(
      {Key? key,
      this.child,
        this.padding,
      this.color,
      this.size = ButtonSize.medium,
      this.block = false,
      this.icon,
      this.shape = ButtonShape.rectangle,
      this.type = ButtonType.normal,
      this.disabled = false,
      this.onClick, this.borderless = false,this.isLoading=false})
      : assert(child != null || icon != null, 'text,icon不能同时为null'),
        super(key: key);

  @override
  State<XDButton> createState() => _XDButtonState();
}

class _XDButtonState extends State<XDButton> {
  late bool _isLoading;
  @override
  void initState() {
    _isLoading=widget.isLoading;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var defaultFontSize=15;

    ///默认的padding
    final EdgeInsets defaultPadding =widget.padding?? EdgeInsets.symmetric(vertical: isMobile?8:15,horizontal: isMobile?12:16);
    var onPressed = widget.disabled ? null :() async {
      setState(() {
        _isLoading = true;
      });
      try{

        await  widget.onClick?.call();

        setState(() {
          _isLoading = false;
        });
      }catch(ex){
        message.error(content: getExceptionMessage(ex)??"操作出现问题，请稍后重试");
        rethrow;
      }finally{
        setState(() {
          _isLoading = false;
        });
      }
    } ;
    var primaryColor = widget.color ?? Theme.of(context).primaryColor;
    var style = ButtonStyle(
      minimumSize: const MaterialStatePropertyAll(Size.zero),
      padding: widget.block
          ? const MaterialStatePropertyAll(EdgeInsets.zero)
          : MaterialStatePropertyAll(defaultPadding * widget.size.getScaleNum()),
      shape: MaterialStatePropertyAll(widget.shape.getShape()),
      textStyle: MaterialStatePropertyAll(Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(
          fontSize: defaultFontSize * widget.size.getScaleNum(),
          height: 1.2,
          color: primaryColor)),
    );

    Widget button ;

    if (widget.type == ButtonType.primary) {
      button = ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          //设置水波纹颜色
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ).merge(style),
        child: getChild(),
      );
    } else if (widget.type == ButtonType.text) {
      button = TextButton(
        onPressed: onPressed,
        style:ButtonStyle(
          foregroundColor:  MaterialStateProperty.all(widget.color),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor:  MaterialStateProperty.all(Colors.transparent),
        ).merge(style),
        child: getChild(),
      );
    }else{
      button = OutlinedButton(
        // focusNode: focusNode,
        onPressed: onPressed,
        style: ButtonStyle(
          //设置水波纹颜色,
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.focused)) {
                return Colors.grey.shade100;
              }
              return null;
            }), foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          // if (states.contains(MaterialState.hovered) ||
          //     states.contains(MaterialState.focused)) {
          //   return primaryColor;
          // }
          return primaryColor.withOpacity(0.8);
        }), side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
          if (widget.borderless == true) {
            return BorderSide.none;
          } else {

            return BorderSide(color: widget.color ?? primaryColor.withOpacity(0.7), width: 1.2);
          }
        })).merge(style),
        child: getChild(),
      );
    }

    if (widget.block) {

      button = SizedBox(
        // if use media query, then will not work for nested widgets.
          width: double
              .infinity, //Or use 'width: MediaQuery.of(context).size.width'
          height: double.infinity,
          child: button);
    } else {
      button = UnconstrainedBox(child: button);
    }

    return button;
  }

  Widget getChild() {
    Color _getColor(){
      if(widget.type==ButtonType.primary){
        return Colors.white;
      }else if(widget.type!=ButtonType.primary &&  widget.color!=null){
        return widget.color!;
      }
      return Colors.blueAccent;
    }
    if(_isLoading){
    return  SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
      ));
    }
    if (widget.child != null && widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [widget.icon!, SizedBox(width: 3,),widget.child!],
      );
    } else if (widget.child != null) {
      return widget.child!;
    } else {
      return widget.icon!;
    }
  }
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLoading=widget.isLoading;
    setState(() {

    });
  }
}
