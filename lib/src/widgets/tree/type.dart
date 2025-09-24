import 'package:x_design/src/utils/extension/iterable_extension.dart';

typedef TreeOnCheck<T> = Function(List<T> checked, List<T> halfChecked,TreeNodeData node);
typedef TreeOnExpand<T> = Function(List<T> expandedKeys);
typedef TreeOnSelect<T> = Function(List<T> selectedKeys);

class TreeDataType<T>  {
  ///唯一标识符
  final T key;

  ///标题
  final String title;

  ///子组件
  final List<TreeDataType<T>>? children;

  ///禁掉响应
  final bool disabled;

  ///是否可用被选中
  final bool selectable;

  final bool  checkable;

  TreeDataType({
    required this.key,
    required this.title,
    this.children,
    this.disabled = false,
    this.selectable = true,
    this.checkable=true,
  });

}

class TreeNodeData<T> implements TreeDataType<T> {
  ///层级
  late int level;

  ///选中复选框状态
  late TreeNodeCheckedStatus checkedStatus;

  ///被展开
  late bool isExpanded;

  ///是否被选中
  late bool isSelected;

  TreeNodeData<T>? parent;

  ///子组件
  @override
  List<TreeNodeData<T>> children=[];



  @override
  final bool  disabled ;

  @override
  T  key ;

  @override
  bool selectable ;

  @override
  String  title ;
  @override
  bool  checkable;
  TreeNodeData({required this.disabled,required this.title,required this.key,required this.selectable,required this.checkable});


}

///树节点的选中复选框状态
enum TreeNodeCheckedStatus {
  ///未被选择
  unChecked,

  ///选中部分
  halfChecked,

  ///选中全部
  checked
}

abstract class TreeModel {
  dynamic getParentId();
  dynamic getId();
  String getTitle();
}



List<TreeDataType<T>> mapToTreeDataType<T extends TreeModel>(List<T> allData,{T? item}) {
  return allData
      .where((element) {
        if(item!=null){
          //如果item不为null,直接取出item的子元素
         return element.getParentId() == item.getId();
        }else{
          //如果item为null,代表时最外层，则取出父id不在allData里的数据
          var allIds=  allData.map((e) => e.getId()).toList();
          return  !allIds.contains(element.getParentId());
        }

      })
      .map((e) {
    var result= TreeDataType<T>(
        title: e.getTitle(), key: e, children: mapToTreeDataType(allData, item:e));
    return result;
  }).toList();
}

int getTreeModelLevel<T extends TreeModel>(List<T> allData, T item){
  var level=1;
  var parent=allData.singleOrDefault((e)=>e.getId()==item.getParentId());
  if(parent!=null){
    level+=getTreeModelLevel(allData, parent);
  }
  return level;
}
