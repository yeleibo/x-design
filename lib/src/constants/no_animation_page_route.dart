import 'package:flutter/material.dart';

typedef RoutePageBuilder = Widget Function(BuildContext context);
///无动画路由
class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  NoAnimationPageRoute({ super.settings, required RoutePageBuilder pageBuilder}):super(transitionDuration:Duration.zero,reverseTransitionDuration:Duration.zero,pageBuilder:(context,_,__){
    return pageBuilder(context);
  } );
}
