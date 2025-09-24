import 'package:flutter/material.dart';
import 'package:x_design/src/theme/theme.dart';

import '../../../services/index.dart';
///主题控制器
class XDThemeController extends ChangeNotifier{
  ///所有支持的主题
  ///  ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),useMaterial3: false),
  final List<ThemeData>? supportedThemes;
  ///当前的主题
  ThemeData? _currentTheme;
  ThemeData get currentTheme=>_currentTheme??ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),useMaterial3: false).copyWith(extensions: [
    XDThemeData(name: "default")
  ]);
  XDThemeController({ this.supportedThemes, ThemeData? initTheme}){
    var themePrimaryColor=dataCacheService.getDataByDataName("themePrimaryColor");
    var theme= supportedThemes?.where((element) => element.primaryColor.value==themePrimaryColor).firstOrNull;
    if(theme==null && initTheme!=null){
      theme??=supportedThemes?.where((element) => element.primaryColor==initTheme.primaryColor).firstOrNull;
    }
    if(theme==null && supportedThemes?.isNotEmpty==true){
      theme=supportedThemes!.first;
    }
    changeTheme(theme);
  }
  ///改变主题
  void changeTheme(ThemeData? theme){
      _currentTheme=theme;
      //缓存
      dataCacheService.saveData("themePrimaryColor", currentTheme.primaryColor.value);
      notifyListeners();
  }

}