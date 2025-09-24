import 'package:flutter/material.dart';

import '../../../xd_design.dart';
import 'type.dart';

class XDInput extends FormField<String> {
  ///是否有边框
  final bool bordered;

  ///大小
  final InputSize size;

  ///是否启用
  final bool disabled;


  ///是否有清除按钮
  final bool allowClear;

  ///提示文字
  final String? placeholder;

  ///最大的文字个数
  final int? maxLength;

  ///最大的行数
  final int? maxLines;
  ///最大的行数
  final int? minLines;
  ///带有前缀图标的 input
  final Widget? prefix;

  ///带有后缀图标的 input
  final Widget? suffix;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final ValueChanged<String>? onChanged;
  XDInput(
      {Key? key,
      this.size = InputSize.medium,
      super.onSaved,
      super.validator,
      this.disabled = false,
      this. onChanged,
        String? initialValue,
      this.allowClear = true,
      this.bordered =true,
      this.placeholder,
      this.prefix,
      this.controller,
      this.focusNode,
      this.suffix,
      this.maxLength,
      this.maxLines = 2,this.minLines=1})
      : super(
            key: key,
            initialValue:    controller != null ? controller.text : initialValue ,
            builder: (FormFieldState<String> field) {
              final _InputState state = field as _InputState;

              // if(disabled) return Text(
              //   initialValue ?? '',
              //   textAlign: TextAlign.right,
              //   overflow: TextOverflow.ellipsis,
              //   softWrap: true,
              // );

              void onChangedHandler(String value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }
              var textTheme = Theme.of(state.context).textTheme;
              var textStyle = size == InputSize.small
                  ? textTheme.bodySmall
                  : size == InputSize.medium
                      ? textTheme.bodyMedium
                      : textTheme.bodyLarge;

              Widget? childIcon = suffix;
              if (childIcon != null || (allowClear && !disabled)) {
                if (allowClear && !disabled) {
                  childIcon = InputClear(
                    textEditingController: state._effectiveController,
                    focusNode: state._focusNode,
                    onChanged: onChanged,
                  );
                }
              }

              ///他的高度是根据里面字体大小来的
              return UnmanagedRestorationScope(
                  bucket: field.bucket,
                  child: TextField(
                    autofillHints: null,
                controller: state._effectiveController,
                onChanged: onChangedHandler,
                enabled: !disabled,
                maxLength: maxLength,
                    maxLines: maxLines,
                minLines: minLines,
                focusNode: state._focusNode,
                style: textStyle?.copyWith(
                    color: disabled ? Colors.grey : null, height: 1.3),
                    textInputAction: TextInputAction.done,
                ///鼠标样式
                mouseCursor: disabled ? SystemMouseCursors.forbidden : null,
                decoration:InputDecoration(
                    isDense: true,
                    prefixIconConstraints: const BoxConstraints(),
                    prefixIcon: prefix != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6 * size.getScaleNum()),
                            child: IconTheme.merge(
                                data: IconThemeData(
                                    size: 18 * size.getScaleNum()),
                                child: prefix))
                        : null,
                    suffixIcon: IconTheme.merge(
                        data: IconThemeData(size: 18 * size.getScaleNum()),
                        child: Container(
                            width: 20,
                            child: childIcon)),
                    suffixIconConstraints: const BoxConstraints(),
                    constraints: const BoxConstraints(),
                    hintText: placeholder ?? XDLocalizations.of(state.context).pleaseEnter,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    // filled: disabled,
                    // fillColor: disabled ? Color(0xfff5f5f5) : null,
                    focusedBorder:isMobile?InputBorder.none: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(state.context).primaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                    disabledBorder:isMobile?InputBorder.none: bordered
                        ? OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3)),
                          )
                        : InputBorder.none,
                    enabledBorder:isMobile?InputBorder.none: bordered
                        ? OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3)),
                          )
                        : InputBorder.none,
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    errorBorder: bordered
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          )
                        : InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(12, 10, 0, 10) *
                        size.getScaleNum()),
              ));
            });

  @override
  FormFieldState<String> createState() => _InputState();
}

class _InputState extends FormFieldState<String> {
  late TextEditingController? controller;
  FocusNode? focusNode;
  ///第一次初始化的值
  String? firstInitialValue;
  XDInput get _input => super.widget as XDInput;
  @override
  void initState() {
    super.initState();
    firstInitialValue=_input.initialValue;
    controller = _input.controller ?? TextEditingController(text: _input.initialValue);
  }
  TextEditingController get _effectiveController=> controller!;


  FocusNode get _focusNode {
    focusNode ??= _input.focusNode ?? FocusNode();
    return focusNode!;
  }

  @override
  void reset() {
    if (controller != null) {
      //这里跟这里跟[TextFormField]不一样
      controller!.text =firstInitialValue?? widget.initialValue?.toString() ?? '';
    }
    _input.onChanged?.call(controller!.text );
    super.reset();
  }
  @override
  void didUpdateWidget(covariant FormField<String> oldWidget) {
    super.didUpdateWidget(oldWidget);
    //这里跟[TextFormField]不一样
    //如果组件聚焦在就不进行改变。
    //[TextFormField]如果initial数据变了后里面显示的数据不跟着变
    // 如果使用是在onChange里调用了setState，并且initial设置成改变的数据。就会出现光标前移。
    // 因为改变时会不断改变Widget的配置。并触发didUpdateWidget。这个时候initial的值时toString生成的。会出现initial的值与textController.text里的值不一致的问题。就会造成textController.selection无效化
    // 例如 double a=1; a.toString() //1.0
    //解决方式就是判断获取焦点时就不根据initialValue给 _effectiveController.text赋值
    if(_focusNode.hasFocus!=true && widget.initialValue!=null){
      _effectiveController.text=widget.initialValue?.toString() ?? '';
    }

  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? "" ;
    }
  }

}

class InputClear extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  const InputClear(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      this.onChanged})
      : super(key: key);

  @override
  State<InputClear> createState() => _InputClearState();
}

class _InputClearState extends State<InputClear> {
  bool textNotEmpty = true;
  bool hasFocus = false;
  @override
  void initState() {
    super.initState();
    textNotEmpty = widget.textEditingController.text.isNotEmpty;
    hasFocus = widget.focusNode.hasFocus;
    widget.textEditingController.addListener(_handTextChange);
    widget.focusNode.addListener(_handFocusChange);
  }

  _handFocusChange() {
    setState(() {
      hasFocus = widget.focusNode.hasFocus;
    });
  }

  _handTextChange() {
    setState(() {
      textNotEmpty = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (hasFocus && textNotEmpty)
        ? InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: const Icon(
              Icons.cancel,
            ),
            onTap: () {
              widget.textEditingController.clear();
              widget.onChanged?.call("");
            },
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handFocusChange);
    widget.textEditingController.removeListener(_handTextChange);
    super.dispose();
  }
}
