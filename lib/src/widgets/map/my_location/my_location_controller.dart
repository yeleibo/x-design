import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x_design/xd_design.dart';


///我的位置控制器
class XDMyLocationController extends ChangeNotifier {
  String mapCode;
  ///我的位置
  LatLng? myPosition;
  ///是否自动移动到地图中心,默认是true
  bool isAutoMoveToMapCenter;
  ///地图控制器
  MapController mapController;
  ///忽略
  bool _ignoreMapEventMove=false;
  StreamSubscription? locationChangListen;
  StreamSubscription? mapChangListen;
  XDMyLocationController({this.isAutoMoveToMapCenter = true,required this.mapController, this.mapCode = ''}) {
    Permission.location.serviceStatus.then((value) {
        if(value!=ServiceStatus.enabled){
          message.info(content: XDLocalizations.of(xdContext).pleaseOpenLocationService);
        }
    });

    //监听我的地址定位变化
    locationChangListen=  locationService.onLocationChange().listen((position) {
      myPosition = LatLng(position.latitude, position.longitude);
      //将地图的中心点移动到我的位置
      moveMapByMyLocation();
      notifyListeners();
    });
    //监听地图移动
    mapController.mapEventStream.listen((event) {
      print(event);
      //如果地图手动移动并且isAutoMoveToMapCenter是true时改变不自动移动到地图中心
      //不忽略地图移动事件并且当前事件是地图移动事件，自动移动到中心是true即非XDMyLocationController移动地图时要将isAutoMoveToMapCenter设置成false
      if(event is MapEventMoveStart){
        //手动移动地图
        isAutoMoveToMapCenter=false;
        notifyListeners();
      }else{
        //程序控制着移动
        if(!_ignoreMapEventMove && event is MapEventMove && isAutoMoveToMapCenter){
          isAutoMoveToMapCenter=false;
          notifyListeners();
        }
      }

    });
  }

  void changeAutoMoveToMapCenter({bool? isAutoMoveToMapCenter}){
    if(isAutoMoveToMapCenter==null){
      this.isAutoMoveToMapCenter=! this.isAutoMoveToMapCenter;
    }else{
      this.isAutoMoveToMapCenter=isAutoMoveToMapCenter;
    }
    //将地图的中心点移动到我的位置
    moveMapByMyLocation();
    notifyListeners();
  }

  //将地图的中心点移动到我的位置
  void moveMapByMyLocation() {
    if(isAutoMoveToMapCenter){
      _ignoreMapEventMove=true;
      if(myPosition!=null && mapController !=null){

        mapController.move(formateFromW84ToOther(mapCode,myPosition!), mapController.camera.zoom);
      }
      //地图的实际移动（MapEventMove）会延迟触发，所有这个地方需要delay一下，不然前面监听的位置里面_ignoreMapEventMove为false
      Future.delayed(const Duration(seconds: 2),(){
        _ignoreMapEventMove=false;
      });

    }
  }
  @override
  void dispose() {
    super.dispose();
    locationChangListen?.cancel();
    mapChangListen?.cancel();

  }
}

LatLng formateFromW84ToOther(String mapCode,LatLng latLng){
  if(mapCode=='gaode'){
    return XDLatLngTransformUtil.gps84ToGcj02(latLng);
  }
  return latLng;
}

LatLng formateFroOtherToW84(String mapCode,LatLng latLng){
  if(mapCode=='gaode'){
    return XDLatLngTransformUtil.gcj02ToGps84(latLng);

  }
  return latLng;
}

