import 'package:flutter/material.dart';

class XDMenuModel {
  String name;
  String code;
  Widget? content;
  bool isCheckPermission;

  List<XDMenuModel>? children;

  ///深度
  late int depth;
  XDMenuModel(
      {required this.name,
        this.content,
        this.children,
        String? code,
        this.isCheckPermission = true})
      :
        code = code ?? name,
        assert(content != null || children != null);

  ///获取叶子节点
  static List<XDMenuModel> getLeafs(List<XDMenuModel> items) {
    var result = <XDMenuModel>[];
    for (var item in items) {
      result.add(item);
      if (item.children?.isNotEmpty == true) {
        result.addAll(getLeafs(item.children!));
      }
    }
    return result;
  }

  ///初始化深度
  static void initDepth(List<XDMenuModel> items, {int depth = 0}) {
    for (var item in items) {
      item.depth = depth;
      if (item.children?.isNotEmpty == true) {
        initDepth(item.children!, depth: depth + 1);
      }
    }
  }
}