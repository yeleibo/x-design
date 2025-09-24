import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_design/xd_design.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> xdNavigatorKey = GlobalKey<NavigatorState>();
///允许您在整个应用程序中显示全局消息
final GlobalKey<ScaffoldMessengerState> xdMessengerKey = GlobalKey<ScaffoldMessengerState>();


final BuildContext xdContext = xdNavigatorKey.currentState!.context;

///xd app
class XDApp extends StatelessWidget {
  final Widget? home;

  ///所有支持的语言
  final List<Locale> supportedLocales;

  ///所有支持的主题
  ///  ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),useMaterial3: false),
  final List<ThemeData>? supportedThemes;

  ///初始化的
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final String title;

  /// {@macro flutter.widgets.widgetsApp.builder}
  ///
  /// Material specific features such as [showDialog] and [showMenu], and widgets
  /// such as [Tooltip], [PopupMenuButton], also require a [Navigator] to properly
  /// function.
  final TransitionBuilder? builder;
  const XDApp(
      {super.key,
      this.home,
      this.title = '',
      this.localizationsDelegates,
      this.builder,
      this.locale,
      this.supportedLocales = const <Locale>[Locale('zh')],
      this.supportedThemes});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => XDLanguageController(
                supportedLocales: supportedLocales,
                initLocaleCode: locale?.languageCode)),
        ChangeNotifierProvider(
            create: (_) => XDThemeController(supportedThemes: supportedThemes)),
      ],
      child: Consumer2<XDLanguageController, XDThemeController>(
        builder: (context, languageController, themeController, Widget? child) {
          return MaterialApp(
            navigatorKey: xdNavigatorKey,
            scaffoldMessengerKey: xdMessengerKey,
            localizationsDelegates: [
              ...?localizationsDelegates,
              //本项目的本地化
              XDLocalizations.delegate,
              //flutter本身组件的国际化
              ...GlobalMaterialLocalizations.delegates,
            ],
            locale: languageController.currentLocale,
            supportedLocales: supportedLocales,
            //切换语言时执行的方法,包含切换系统语言和自己更改语言即修改locale
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              return languageController.supportedLocales
                  .where((element) =>
                      element.languageCode == deviceLocale!.languageCode&&element.countryCode == deviceLocale.countryCode)
                  .firstOrNull;
            },
            theme: themeController.currentTheme,
            debugShowCheckedModeBanner: false, home: home,
            builder: builder,
            onUnknownRoute: (_) {
              return MaterialPageRoute<void>(
                builder: (BuildContext context) =>  _NotFoundPage(),
              );
            },
          );
        },
      ),
    );
  }
}


///页面不存在
class _NotFoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("page not found"),),
    );
  }
}