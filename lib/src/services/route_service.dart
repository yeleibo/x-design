// import 'package:flutter/cupertino.dart';
// import 'package:get_it/get_it.dart';
// var routeService=GetIt.I<RouteService>();
// abstract class RouteService {
//   RouteFactory? onGenerateRoute;
//
//   final GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();
//   ///初始化方法，给onGenerateRoute赋值，以及处理未知路由
//   @mustCallSuper
//   void init();
//
//   ///注册路由
//   void registerRoute(String routeName, RouteHandlerFunc routeHandlerFunction);
//
//   ///页面调整
//   Future? navigateTo(String routeString,
//       {dynamic data, bool replace = false,bool clearStack = false});
//   T? getRouteData<T>(BuildContext? context);
// }
//
// typedef RouteHandlerFunc = Widget? Function(
//     BuildContext? context, Map<String, List<String>> parameters);
