import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

var locationService=GetIt.I.get<LocationService>();

abstract class LocationService{
  Future<void> init();
  ///地址改变
  Stream<XDLocation> onLocationChange() ;
  ///获取当前的位置
  Future<XDLocation> getCurrentPosition() ;
  ///获取最新一次的位置
  XDLocation? getLastPosition();
}

class XDLocation{
  ///纬度
  final double latitude;
  ///经度
  final double longitude;
  ///海拔高度
  final double? altitude;
  XDLocation({ required this.latitude, required this.longitude,this.altitude});

  LatLng get latLng=>LatLng(latitude,longitude);

  @override
  String toString() {
    return "经度:$longitude,维度:$latitude,海拔:$altitude";
  }
}

mixin  LocationBase{
  final StreamController<XDLocation> streamController=StreamController.broadcast();
  Stream<XDLocation> onLocationChange()  {
    return streamController.stream;
  }

  Future<XDLocation> getCurrentPosition() {
    return streamController.stream.last;
  }
}