import 'package:flutter/material.dart';
import 'package:x_design/xd_design.dart';




///查询条件

class XDQueryConditions<T> extends StatefulWidget {
  final VoidCallback onSearch;
  final VoidCallback onReset;
  final List<Widget> alwaysShowChildren;
  final List<Widget>? hideChildren;
  final bool initExpanded;


   const XDQueryConditions(
      {Key? key,
      this.hideChildren,
      required this.onReset,
      required this.onSearch,
      required this.alwaysShowChildren,
      this.initExpanded = true})
      : super(key: key);

  @override
  State<XDQueryConditions<T>> createState() => _XDQueryConditionsState<T>();
}

class _XDQueryConditionsState<T> extends State<XDQueryConditions<T>> {
  final _formKey = GlobalKey<FormState>();
  late bool expanded;
  @override
  void initState() {
    super.initState();
    expanded=widget.initExpanded;
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.addAll(widget.alwaysShowChildren);
    if (expanded == true && widget.hideChildren != null) {
      children.addAll(widget.hideChildren!);
    }
    children.add(Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: XDButton(
              type: ButtonType.primary,
              onClick: () {
                var state = _formKey.currentState;
                if (state?.validate() == true) {
                  state?.save();
                  widget.onSearch();
                }
              },
              child:  Text(XDLocalizations.of(context).search),
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: XDButton(
              child:  Text(XDLocalizations.of(context).reset),
              onClick: () {
                _formKey.currentState?.reset();
                _formKey.currentState?.save();
                widget.onReset();
              },
            )),
        if (widget.hideChildren != null)
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: XDButton(
                // size: ButtonSize.small,
                //icon:  Icon(!widget.expand?Icons.chevron_right:Icons.expand_more),

                child: Text(expanded ?  '收起': '展开'),
                onClick: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ))
      ],
    ));

    return Form(
      key: _formKey,
      child: Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,

              children: children)),
    );
  }
}
