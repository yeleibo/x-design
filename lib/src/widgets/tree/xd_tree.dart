import 'package:flutter/material.dart';

import 'type.dart';

///https://tdesign.tencent.com/vue/widgets/tree
///https://ant.design/widgets/tree-cn

class XDTree<T> extends StatefulWidget {
  final List<TreeDataType<T>> treeData;
  final bool checkable;

  /// 父子节点选中状态不再关联，可各自选中或取消
  final bool checkStrictly;

  ///初始化checkBox选中的数据数据
  final List<T> defaultCheckedKeys;

  ///默认展开所有树节点
  final bool defaultExpandAll;

  ///默认展开的数据
  final List<T> defaultExpandedKeys;

  ///默认选中的数据
  final List<T> defaultSelectedKeys;

  ///节点选中事件
  final TreeOnCheck<T>? onCheck;

  ///节点展开事件
  final TreeOnExpand<T>? onExpand;

  ///节点选择事件
  final TreeOnSelect<T>? onSelect;

  ///节点点击事件
  final Function? onClick;

  ///多选
  final bool multiple;

  ///展开的keys
  final List<T> expandedKeys;
  const XDTree(
      {super.key,
      required this.treeData,
      this.checkStrictly = true,
      this.defaultCheckedKeys = const [],
      this.defaultExpandedKeys = const [],
      this.defaultSelectedKeys = const [],
      this.multiple = false,
      this.defaultExpandAll = false,
      this.checkable = false,
      this.onCheck,
      this.onClick,
      this.onExpand,
      this.onSelect,
      this.expandedKeys = const []})
      : assert(!(!multiple && defaultCheckedKeys.length>1),"单选时，默认选中的数组数据长度不能大于1");

  @override
  State<XDTree<T>> createState() => _XDTreeState<T>();
}

class _XDTreeState<T> extends State<XDTree<T>> {

   List<TreeNodeData<T>> treeNodesData=[];
  ///一维数组
  var oneDimensionalNodeList = <TreeNodeData<T>>[];
  @override
  void initState() {
    super.initState();
    _initTreeData();
  }

  void _initTreeData() {
    treeNodesData.clear();
    for (var element in widget.treeData) {
      treeNodesData.add(_initTreeDataNode(element, 0));
    }
  }

  ///初始化Level属性
   TreeNodeData<T> _initTreeDataNode(TreeDataType<T> item, int level) {
    var treeNode= TreeNodeData<T>(key: item.key,title: item.title,selectable: item.selectable,disabled: item.disabled,checkable: item.checkable);
    treeNode.level = level;

    oneDimensionalNodeList.add(treeNode);
    if (item.children != null) {
      for (var element in item.children!) {

       var child= _initTreeDataNode(element, level + 1);
        ///初始化父数据
       child.parent = treeNode;
       treeNode.children.add(child);
      }
    }
    _checkTreeDataExpanded(treeNode);

    _checkTreeDataChecked(treeNode);
    _checkTreeDataSelected(treeNode);
    return treeNode;
  }

  ///检查是否展开
  void _checkTreeDataExpanded(TreeNodeData<T> item) {
    if (widget.defaultExpandAll) {
      item.isExpanded = true;
    } else {
      if (widget.defaultExpandedKeys.contains(item.key)) {
        item.isExpanded = true;
      } else {
        item.isExpanded = false;
      }
    }
  }

  ///检查是否被选中
  void _checkTreeDataChecked(TreeNodeData<T> item) {
    if(widget.multiple){
      item.checkedStatus = (widget.defaultCheckedKeys.contains(item.key) || ( item.children.isNotEmpty && item.children.where((element) => element.checkedStatus==TreeNodeCheckedStatus.checked).length==item.children.length))
          ? TreeNodeCheckedStatus.checked
          : TreeNodeCheckedStatus.unChecked;
    }else{
      item.checkedStatus = widget.defaultCheckedKeys.contains(item.key)
          ? TreeNodeCheckedStatus.checked
          : TreeNodeCheckedStatus.unChecked;
    }

  }

  ///检查是否被选中
  void _checkTreeDataSelected(TreeNodeData<T> item) {
    item.isSelected = widget.defaultSelectedKeys.contains(item.key);
  }

  @override
  Widget build(BuildContext context) {
    return TreeNodeState(
        checkStrictly: widget.checkStrictly,
        checkable: widget.checkable,
        multiple: widget.multiple,
        oneDimensionalNodeList: oneDimensionalNodeList,
        onExpanded: () {
          setState(() {
            widget.onExpand?.call(oneDimensionalNodeList
                .where((element) => element.isExpanded)
                .map((e) => e.key)
                .toList());
          });
        },
        onCheck: (node) {
          setState(() {
            widget.onCheck?.call(
                oneDimensionalNodeList
                    .where((element) =>
                        element.checkedStatus == TreeNodeCheckedStatus.checked)
                    .map((e) => e.key)
                    .toList(),
                oneDimensionalNodeList
                    .where((element) =>
                        element.checkedStatus ==
                        TreeNodeCheckedStatus.halfChecked)
                    .map((e) => e.key)
                    .toList(),node);
          });
        },
        onSelect: () {
          setState(() {
            widget.onSelect?.call(
              oneDimensionalNodeList
                  .where((element) => element.isSelected)
                  .map((e) => e.key)
                  .toList(),
            );
          });
        },

        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: treeNodesData
                .map((e) => TreeNode<T>(
                      nodeData: e,
                    ))
                .toList()));
  }

  @override
  void didUpdateWidget(covariant XDTree<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    ///更新选中状态
    for(var item in oneDimensionalNodeList){
      _checkTreeDataChecked(item);
    }
  }
}

///树节点
class TreeNode<T> extends StatelessWidget {
  final TreeNodeData<T> nodeData;
  const TreeNode({super.key, required this.nodeData});

  @override
  Widget build(BuildContext context) {
    var treeNodeState = TreeNodeState.of<T>(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20.0 * (nodeData.level),
            ),
            (nodeData.children.isNotEmpty)
                ? InkWell(
                    child: Icon(nodeData.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right),
                    onTap: () {
                      treeNodeState.updateExpanded(nodeData);
                    },
                  )
                : Container(
                    width: 25,
                  ),
            treeNodeState.checkable == true
                ? GestureDetector(
                    onTap: () {
                      treeNodeState.updateChecked(nodeData);
                    },
                    child: buildNodeCheckIcon(nodeData),
                  )
                : const SizedBox(),
            Container(
              color: nodeData.isSelected
                  ? Colors.blueAccent.withOpacity(0.5)
                  : null,
              child: Text(nodeData.title),
            ),
          ],
        ),
        if (nodeData.isExpanded)
          ...nodeData.children.map((e) => TreeNode<T>(nodeData: e))
      ],
    );
  }

  Widget buildNodeCheckIcon(TreeNodeData<T> node) {
    if(!node.checkable){
      return const SizedBox(width: 10,);
    }
    switch (node.checkedStatus) {
      case TreeNodeCheckedStatus.unChecked:
        return const Icon(
          Icons.check_box_outline_blank,
          color: Color(0XFFCCCCCC),
        );
      case TreeNodeCheckedStatus.halfChecked:
        return const Icon(
          Icons.indeterminate_check_box,
          color: Color(0X990000FF),
        );
      case TreeNodeCheckedStatus.checked:
        return const Icon(
          Icons.check_box,
          color: Color(0X990000FF),
        );
      default:
        return const Icon(Icons.remove);
    }
  }
}

class TreeNodeState<T> extends InheritedWidget {
  ///节点checkBox选中事件
  final Function(TreeNodeData node) onCheck;

  ///节点展开
  final Function onExpanded;

  ///节点选中
  final Function onSelect;
  final bool checkable;
  final bool checkStrictly;

  ///多选
  final bool multiple;

  ///一维数组
  final List<TreeNodeData<T>> oneDimensionalNodeList;
  const TreeNodeState(
      {Key? key,
      required this.checkStrictly,
      required this.checkable,
      required this.multiple,
      required Widget child,
      required this.onExpanded,
      required this.onSelect,
      required this.onCheck,
      required this.oneDimensionalNodeList})
      : super(key: key, child: child);

  static TreeNodeState<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TreeNodeState<T>>();
  }

  void updateExpanded(TreeNodeData treeData) {
    treeData.isExpanded = !treeData.isExpanded;
    onExpanded();
  }

  void updateSelected(TreeNodeData treeData) {
    treeData.isSelected = !treeData.isSelected;
    onSelect();
  }

  void updateChecked(TreeNodeData node) {
    if(!checkable){
      return;
    }
    if(multiple){
      if (node.checkedStatus == TreeNodeCheckedStatus.unChecked) {
        node.checkedStatus = TreeNodeCheckedStatus.checked;
        //非严格模式就需要选中自己的子节点
        if (checkStrictly) {
          node.checkedStatus = TreeNodeCheckedStatus.checked;
        } else {
          _checkedChildrenNode(node);
          _updateParentNode(node);
        }
      } else {
        //非严格模式就需要移除选中的子节点
        if (checkStrictly) {
          node.checkedStatus = TreeNodeCheckedStatus.unChecked;
        } else {
          _uncheckedChildrenNode(node);
          _updateParentNode(node);
        }
      }
    }else{
      //单选就清楚掉之前选中的
      if(node.checkedStatus==TreeNodeCheckedStatus.unChecked){
        var checked=oneDimensionalNodeList.where((element) => element.checkedStatus==TreeNodeCheckedStatus.checked).toList();
        for(var item in checked){
          item.checkedStatus= TreeNodeCheckedStatus.unChecked;
        }
        node.checkedStatus=TreeNodeCheckedStatus.checked;
      }else{
        node.checkedStatus=TreeNodeCheckedStatus.unChecked;
      }


    }

    onCheck(node);
  }

  ///改变子节点选中状态
  void _checkedChildrenNode(TreeNodeData item) {
    item.checkedStatus = TreeNodeCheckedStatus.checked;
    if (item.children.isEmpty) return;
    for (var child in item.children) {
      _checkedChildrenNode(child);
    }
  }

  ///改变子节点选中状态
  void _uncheckedChildrenNode(TreeNodeData item) {
    item.checkedStatus = TreeNodeCheckedStatus.unChecked;
    if (item.children.isEmpty) return;
    for (var child in item.children) {
      _uncheckedChildrenNode(child);
    }
  }

  /// 改变父节点选中状态
  _updateParentNode(TreeNodeData item) {
    if (item.parent == null || item.parent!.checkable==false) return;
    var par = item.parent!;

    int checkedChildrenCount = 0;

    for (var child in par.children) {
      if (child.checkedStatus == TreeNodeCheckedStatus.checked) {
        checkedChildrenCount++;
      }
    }

    // 如果子孩子全都是选择的， 父节点就全选

    if (checkedChildrenCount == par.children.length) {
      par.checkedStatus = TreeNodeCheckedStatus.checked;
    } else if (checkedChildrenCount == 0) {
      par.checkedStatus = TreeNodeCheckedStatus.unChecked;
    } else {
      par.checkedStatus = TreeNodeCheckedStatus.halfChecked;
    }

    // 如果还有父节点 解析往上更新
    if (par.parent != null) {
      _updateParentNode(par);
    }
  }

  @override
  bool updateShouldNotify(TreeNodeState oldWidget) {
    return true;
  }
}
