import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:x_design/xd_design.dart';
///地图中心经纬度图层
class XDMapCenterLatLngLayer extends StatelessWidget {
  final Color? color;
  const XDMapCenterLatLngLayer({super.key,this.color= Colors.blueAccent});

  @override
  Widget build(BuildContext context) {
    //这里依赖自MapCamera，MapCamera改变时build方法会重构，如果依赖自MapController位置改变时就不会发生改变
    var mapCamera=MapCamera.of(context);
    return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
            child: Text(
              "${XDLocalizations.of(context).mapCenter}:${mapCamera.center.latitude.toStringAsFixed(6)},${mapCamera.center.longitude.toStringAsFixed(6)},${kDebugMode?mapCamera.zoom.toStringAsFixed(2):''}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )));
  }
}
