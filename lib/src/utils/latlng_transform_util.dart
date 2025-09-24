import 'dart:math';

import 'package:latlong2/latlong.dart';
///经纬度转换工具
class XDLatLngTransformUtil {
  static const double pi = 3.1415926535897932384626;
  static const double xPi = 3.14159265358979324 * 3000.0 / 180.0;
  static const double a = 6378245.0;
  static const double ee = 0.00669342162296594323;

  static double transformLat(double x, double y) {
    double ret = -100.0 +
        2.0 * x +
        3.0 * y +
        0.2 * y * y +
        0.1 * x * y +
        0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double transformLon(double x, double y) {
    double ret =
        300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret +=
        (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }

  static List<double> transform(double lat, double lon) {
    if (outOfChina(lat, lon)) {
      return [lat, lon];
    }
    double dLat = transformLat(lon - 105.0, lat - 35.0);
    double dLon = transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);

    return [dLat, dLon];
  }

  static bool outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  /// 84 to 火星坐标系 (GCJ-02)
  static LatLng gps84ToGcj02(LatLng gps84LatLng) {
    if (outOfChina(gps84LatLng.latitude, gps84LatLng.longitude)) {
      return gps84LatLng;
    }
    var offset = transform(gps84LatLng.latitude, gps84LatLng.longitude);
    return LatLng(gps84LatLng.latitude + offset.first, gps84LatLng.longitude + offset.last);
  }

  ///火星坐标系 (GCJ-02) to 84
  static LatLng gcj02ToGps84(LatLng gcj02LatLng) {
    //如果不判断会卡住
    if (outOfChina(gcj02LatLng.latitude, gcj02LatLng.longitude)) {
      return gcj02LatLng;
    }
    List<double> offset;
    var latitude=gcj02LatLng.latitude;
    var longitude=gcj02LatLng.longitude;

    double dx = 1e-6;
    do{
      var tempGps84latLng=LatLng(latitude,longitude);
      var t = transform(latitude, longitude);
      latitude=gcj02LatLng.latitude-t.first;
      longitude=gcj02LatLng.longitude-t.last;

      offset=[tempGps84latLng.latitude-latitude,tempGps84latLng.longitude-longitude];
    }
    while (offset.first.abs() >= dx || offset.last.abs() >= dx);
    return LatLng(latitude, longitude);
  }

  /// 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
  ///
  /// @param lat
  /// @param lon
  static LatLng gcj02ToBd09(LatLng point) {
    if (outOfChina(point.latitude, point.longitude)) {
      return point;
    }
    double x = point.longitude, y = point.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) + 0.000003 * cos(x * xPi);
    double tempLon = z * cos(theta) + 0.0065;
    double tempLat = z * sin(theta) + 0.006;
    return LatLng(tempLat, tempLon);
  }

  // /**
  //  * * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标
  //  * @param lat
  //  * @param lon
  //  * @return
  //  */
  // static List<double> bd09_To_Gcj02(double lat, double lon) {
  //   double x = lon - 0.0065, y = lat - 0.006;
  //   double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
  //   double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
  //   double tempLon = z * cos(theta);
  //   double tempLat = z * sin(theta);
  //   List<double> gps = [tempLat, tempLon];
  //   return gps;
  // }
  //
  /// 将gps84转为bd09
  ///
  /// @param lat
  /// @param lon
  /// @return
  static Future<LatLng> gps84ToBd09(LatLng point) async {
    if (outOfChina(point.latitude, point.longitude)) {
      return point;
    }
    LatLng gcj02 = gps84ToGcj02(point);
    LatLng bd09 = gcj02ToBd09(gcj02);
    return bd09;
    //直接使用w84转百度的接口会有问题，所以先转火星坐标系,再调用百度接口
    // point=gps84ToGcj02(point);
    // var result=await Dio().get<Map<String,dynamic>>("https://api.map.baidu.com/geoconv/v1/?coords=${point.latitude},${point.longitude}&from=3&to=5&ak=k1TMgjpAKlxF3aYapdlQSMDkmy6h7eEa").then((value) => value.data);
    // return LatLng(result!['result'][0]['x'] as double, result['result'][0]['y'] as double);
  }
  //
  // static List<double> bd09_To_gps84(double lat, double lon) {
  //   List<double> gcj02 = bd09_To_Gcj02(lat, lon);
  //   List<double> gps84 = gcj02_To_Gps84(gcj02[0], gcj02[1]);
  //   //保留小数点后六位
  //   gps84[0] = retain6(gps84[0]);
  //   gps84[1] = retain6(gps84[1]);
  //   return gps84;
  // }

  /// 保留小数点后六位
  ///
  /// @param double
  /// @return
  static double retain6(double n) {
    return double.parse(n.toStringAsFixed(6));
  }



}
