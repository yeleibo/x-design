import 'package:flutter/material.dart';
import 'package:x_design/src/widgets/dialog/xd_dialog.dart';
import 'package:x_design/src/utils/extension/iterable_extension.dart';

import '../../../xd_design.dart';
import '../button/type.dart';
import '../input/xd_input.dart';

class XDSelectTreeDialog<T> extends StatefulWidget {
  final Function(List<T> checkedKeys)? onConfirm;
  final List<TreeDataType<T>> treeData;

  ///被选中的key
  final List<T> defaultCheckedKeys;

  ///是否可多选
  final bool multiple;

  ///查询
  final bool Function(TreeDataType<T> item,String keyword)? search;
  const XDSelectTreeDialog(
      {super.key,
      this.multiple = false,
      this.defaultCheckedKeys = const [],
      required this.treeData,
      this.onConfirm,
      this.search});

  @override
  State<XDSelectTreeDialog<T>> createState() => _XDSelectTreeDialogState<T>();
}

class _XDSelectTreeDialogState<T> extends State<XDSelectTreeDialog<T>> {
  var keyword = "";

  ///一维数组
  var oneDimensionalNodeList = <TreeDataType<T>>[];

  var checked = <TreeDataType<T>>[];
  @override
  void initState() {
    super.initState();
    for (var element in widget.treeData) {
      _init(element);
    }
    checked=oneDimensionalNodeList.where((element) => widget.defaultCheckedKeys.contains(element.key)).toList();
  }

  _init(TreeDataType<T> element) {
    oneDimensionalNodeList.add(element);
    if (element.children != null) {
      for (var child in element.children!) {
        _init(child);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return XDDialog(
        actions: [
          XDButton(
            child:  Text(XDLocalizations.of(context).cancel),
            onClick: () {
              Navigator.of(context).pop();
            },
          ),
          XDButton(
            type: ButtonType.primary,
            onClick: () {
              widget.onConfirm?.call(checked.map((e) => e.key!).toList());

            },
            child:  Text(XDLocalizations.of(context).confirm),
          )
        ],
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: XDInput(
                            initialValue: keyword,
                            onChanged: (value) {
                              keyword = value;
                              setState(() {});
                            },
                          )),
                          const SizedBox(
                            width: 20,
                          ),
                          XDButton(
                            type: ButtonType.primary,
                            onClick: () {
                              setState(() {});
                            },
                            child:  Text(XDLocalizations.of(context).search),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5)),
                      child: (keyword.isNotEmpty)
                          ? ListView(
                              children: oneDimensionalNodeList
                                  .where((element) =>
                                      element.checkable && (widget.search != null
                                          ? widget.search!.call(element,keyword)
                                          : element.title.contains(keyword)))
                                  .map((e) => ListTile(
                                        selected: checked.contains(e),
                                        onTap: () {
                                          setState(() {
                                            if (widget.multiple) {
                                              if (!checked.contains(e)) {
                                                checked.add(e);
                                              }else{
                                                checked.remove(e);
                                              }
                                            } else {
                                              checked.clear();
                                              if (!checked.contains(e)) {
                                                checked.add(e);
                                              }
                                            }

                                          });
                                        },
                                        title: Text(e.title),
                                        subtitle: Text(getParentName(e)),
                                      ))
                                  .toList(),
                            )
                          : SingleChildScrollView(
                              child: XDTree(
                                treeData: widget.treeData,
                                defaultCheckedKeys:
                                    checked.map((e) => e.key).toList(),
                                checkable: true,
                                checkStrictly: !widget.multiple,
                                multiple: widget.multiple,
                                onCheck: (treeChecked, halfChecked,node) {
                                  setState(() {
                                    checked = oneDimensionalNodeList
                                        .where((element) =>
                                            treeChecked.contains(element.key))
                                        .toList();
                                  });
                                },
                              ),
                            ),
                    ))
                  ],
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(children: [
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(XDLocalizations.of(context).selected,
                            style: Theme.of(context).textTheme.bodyLarge),
                        InkWell(
                          child: Text(XDLocalizations.of(context).clearList,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.red.shade300)),
                          onTap: () {
                            setState(() {
                              checked.clear();
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5)),
                          child: ListView(
                            children: [
                              if (checked.isNotEmpty)
                                ...checked.map((e) => ListTile(
                                      title: Text(e.title),
                                      subtitle: Text(getParentName(e)),
                                      trailing: InkWell(
                                          onTap: () {
                                            setState(() {
                                              checked.remove(e);
                                            });
                                          },
                                          child: const Icon(Icons.delete)),
                                    ))
                            ],
                          )))
                ]))
              ],
            )));
  }

  String getParentName(TreeDataType element) {
    var result = '';
    var parent = oneDimensionalNodeList
        .where((e) => e.children != null && e.children!.contains(element))
        .firstOrDefault();
    if (parent != null) {
      result += "${getParentName(parent)}/${parent.title}";
    }
    return result;
  }
}
