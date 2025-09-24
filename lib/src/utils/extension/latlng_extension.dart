import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../../../xd_design.dart';

///经纬度的扩展
extension LatLngExtension on LatLng {
  ///latlng中的经纬度必须是w84的值
  Future<String?> addressFromTianditu({required String tiandituMapKey}) async {
    //从天地图进行查询
    var dio = Dio();
    dio.interceptors.add(XDDioCommonInterceptor());
    var responseString = await dio.get<String>(
        "http://api.tianditu.gov.cn/geocoder?postStr={'lon':$longitude,'lat':$latitude,'ver':1}&type=geocode&tk=$tiandituMapKey");
    if (responseString.data != null) {
      var response = jsonDecode(responseString.data!);
      if (response['status'] == '0') {
        return response?['result']?['formatted_address'];
      }
    }
    return null;
  }

  Future<String?> addressFromGaode({required String gaodeMapKey}) async {
    //从高德地图进行查询
    var j02LatLng = XDLatLngTransformUtil.gps84ToGcj02(this);
    var dio = Dio();
    dio.interceptors.add(XDDioCommonInterceptor());
    var response = await dio
        .get<Map<String, dynamic>>(
            'https://restapi.amap.com/v3/geocode/regeo?key=$gaodeMapKey&location=${j02LatLng.longitude},${j02LatLng.latitude}')
        .then((value) => value.data);
    return response?['regeocode']?['formatted_address'];
  }

  Future<String?> addressFromGoogle(
      {required String googleMapKey, String language = "zh-CN"}) async {
    //从google进行查询
    // https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding?hl=zh-cn
    // https://www.cnblogs.com/liuhaorain/archive/2012/01/31/2334018.html#!comments
    var dio = Dio();
    dio.interceptors.add(XDDioCommonInterceptor());
    var response = await dio
        .get<Map<String, dynamic>>(
            'https://maps.google.com/maps/api/geocode/json?key=$googleMapKey&latlng=$latitude,$longitude&language=$language')
        .then((value) => value.data);

    return (response?['results'] as List?)?.firstOrNull?['formatted_address'];
  }
}

extension LatLngListExtension on List<LatLng>? {
  ///获取中心点
  LatLng? get center => this == null
      ? null
      : this!.isEmpty
          ? null
          : LatLng(
              this!
                      .map((e) => e.latitude)
                      .reduce((value, element) => (value + element)) /
                  this!.length,
              this!
                      .map((e) => e.longitude)
                      .reduce((value, element) => value + element) /
                  this!.length);
}
