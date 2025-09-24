import 'package:flutter/material.dart';
import 'package:x_design/src/widgets/xd_app.dart';

/// 自定义的主题数据
/// theme:ThemeData.light().copyWith(
///        extensions: <ThemeExtension<dynamic>>[
///           const XDThemeData(
///             name: "扩展主题",
///           ),
///        ],
///       )
/// 使用 Theme.of(context).extension<XDThemeData>()!; or XDThemeData.of(context)
class XDThemeData extends ThemeExtension<XDThemeData> {
  /// 名称
  late String name;
  XDThemeData({required this.name});

  factory  XDThemeData.defaultData(){
    return XDThemeData(name: "default");
  }

  @override
  ThemeExtension<XDThemeData> copyWith() {
   return XDThemeData(name: name);
  }

  @override
  ThemeExtension<XDThemeData> lerp(covariant ThemeExtension<XDThemeData>? other, double t) {
    if (other is! XDThemeData) {
      return this;
    }
    return XDThemeData(name: other.name);
  }
  static XDThemeData of([BuildContext? context]){
    return  Theme.of(context??xdContext).extension<XDThemeData>()??XDThemeData.defaultData();
  }
}
