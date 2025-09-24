import 'package:flutter/material.dart';

class XDSelect<T> extends StatefulWidget {
  ///是否多选
  final bool multiple;
  ///选项改变时调用
  final Function(List<T> selectedData)? onChange;
  ///数据化配置选项内容
  final List<XDSelectOption<T>>? options;
  const XDSelect({super.key,this.multiple=false, this.onChange, this.options});

  @override
  State<XDSelect> createState() => _XDSelectState();
}

class _XDSelectState extends State<XDSelect> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){},child: Container(width: 200,child:Wrap(children: [
      Container(child: Row(children: [Text("选中1"),Icon(Icons.close)],),)
    ],) ,),);
  }
}


///下拉选项类
class XDSelectOption<T>{
  ///显示的标签类别
  String label;
  ///下拉选项的值
  T value;
  ///是否被禁用
  bool disabled;
  XDSelectOption({required this.label,required this.value,this.disabled=false});
}

