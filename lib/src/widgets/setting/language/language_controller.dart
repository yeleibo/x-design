import 'package:flutter/cupertino.dart';
import 'package:x_design/src/services/data_cache_service.dart';
///语言控制器
///       ChangeNotifierProvider(
///         create: (_) => XDLanguageController(
///          supportedLocales: [Locale("zh"), Locale("en")]),
///         child: Consumer<XDLanguageController>(builder:))
class XDLanguageController extends ChangeNotifier{
  ///支持的语言
  final List<Locale> supportedLocales;
  ///当前语言，为null时代表跟随系统
  Locale? currentLocale;
  XDLanguageController({required this.supportedLocales,String? initLocaleCode}){
   var cacheLanguageCode=dataCacheService.getDataByDataName("languageCode");
    var initLocale= supportedLocales.where((element) => element.languageCode==cacheLanguageCode).firstOrNull;
   initLocale??=supportedLocales.where((element) => element.languageCode==initLocaleCode).firstOrNull;
   changeLanguage(initLocale);
  }
  ///改变语言
  void changeLanguage(Locale? locale){
    currentLocale=locale;
    //缓存
    dataCacheService.saveData("languageCode", currentLocale?.languageCode);
    notifyListeners();
  }

  static String languageString(Locale? locale){
    if (locale?.languageCode == null) {
      return '跟随系统';
    }

    final languageMap = {
      'zh': locale?.countryCode == "TW" ? '繁體中文' : '简体中文',
      'en': 'English',
      'id': 'Bahasa Indonesia',
    };

    return languageMap[locale!.languageCode] ?? "Unknown language";
  }

  ///当前语言的名称
  String get currentLocaleName=>languageString(currentLocale);

}