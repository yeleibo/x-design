import 'dart:async';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import '../../xd_design.dart';

///地图操作工具汇总
class XDMapUtil {
  ///地理编码
  static Future<List<dynamic>?> searchAddressFromGoogle({
    required String googleMapApiKey,
    required String textQuery,
  }) async {
    var header = {
      'X-Goog-FieldMask': 'places.id,places.displayName,places.location',
      'X-Goog-Api-Key' : googleMapApiKey,
    };
    BaseOptions options = BaseOptions(method: 'POST', headers: header);
    var dio = Dio(options);
    dio.interceptors.add(XDDioCommonInterceptor());
    List? data;
    var response = await dio
        .post("https://places.googleapis.com/v1/places:searchText", data: {
      'textQuery': textQuery,
    });
    if (response.data != null) {
      if (response.statusCode == 200) {
        data =  response.data['places'];
      }
    }
    return data;
  }

  static dynamic searchKeywordFromGoogle() {}

  ///经纬度转天地图地址
  static Future<String?> addressFromTianditu(
      LatLng latLng, String tiandituMapKey) async {
    return await latLng.addressFromTianditu(tiandituMapKey: tiandituMapKey);
  }

  ///经纬度转高德地址
  static Future<String?> addressFromGaode(
      LatLng latLng, String gaodeMapKey) async {
    return await latLng.addressFromGaode(gaodeMapKey: gaodeMapKey);
  }

  ///经纬度转谷歌地址
  static Future<String?> addressFromGoogle(
      LatLng latLng, String googleMapKey) async {
    return await latLng.addressFromGoogle(googleMapKey: googleMapKey);
  }

  ///启动地图
  static Future<void> launchMapApp({required LatLng point,required String title}) async {
    var googleMap = await MapLauncher.isMapAvailable(MapType.google);
    if (googleMap != null && googleMap) {
      //
      await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: Coords(point.latitude, point.longitude),
          title: title
      );
      return ;
    }
    var amap = await MapLauncher.isMapAvailable(MapType.amap);
    if (amap != null && amap) {
      //高德是自己的坐标系
      point= XDLatLngTransformUtil.gps84ToGcj02(point);
      await MapLauncher.showMarker(
          mapType: MapType.amap,
          coords: Coords(point.latitude, point.longitude),
          title: title
      );
      return ;
    }
    var baidu = await MapLauncher.isMapAvailable(MapType.baidu);
    if (baidu != null && baidu) {
      point=  await XDLatLngTransformUtil.gps84ToBd09(point);
      //这里对百度地图可能做过处理
      await MapLauncher.showMarker(
          mapType: MapType.baidu,
          coords: Coords(point.latitude, point.longitude),
          title: title
      );
      return ;
    }

    var tencent = await MapLauncher.isMapAvailable(MapType.tencent);
    if (tencent != null && tencent) {
      point= XDLatLngTransformUtil.gps84ToGcj02(point);
      await MapLauncher.showMarker(
          mapType: MapType.tencent,
          coords: Coords(point.latitude, point.longitude),
          title: title
      );
      return ;
    }

    message.info(content: XDLocalizations.of(xdContext).installMapApp);
  }
}
