import 'dart:async';
import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x_design/xd_design.dart';


///只支持ios和android
class LocationServiceImplementByAMap with LocationBase implements LocationService {
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  final String gaodeMapKeyOfAndroid;
  final String gaodeMapKeyOfIos;
  XDLocation? lastPosition;

  bool inited=false;

  LocationServiceImplementByAMap(
      {required this.gaodeMapKeyOfAndroid, required this.gaodeMapKeyOfIos});


  @override
  Future<bool> init() async {
    if(inited)return true;
    // 定位权限检查
   var locationPermission= await Permission.location.status;
   if(locationPermission!= PermissionStatus.granted){
     locationPermission=await Permission.location.request();
     if(locationPermission != PermissionStatus.granted){
       return Future.error("未给定位权限");
     }
   }
   AMapFlutterLocation.updatePrivacyShow(true, true);
   AMapFlutterLocation.updatePrivacyAgree(true);
    //定位服务检查
    var serviceStatus = await Permission.location.serviceStatus;


      if(serviceStatus == ServiceStatus.disabled){
        return Future.error("定位服务未开启");
      }


    AMapFlutterLocation.setApiKey(gaodeMapKeyOfAndroid, gaodeMapKeyOfIos);
   _locationPlugin.onLocationChanged().listen((result) {
        if (result['longitude'] != null) {

          var longitude =Platform.isAndroid?result['longitude'] as double: double.tryParse(result['longitude'] as String);
          var latitude = Platform.isAndroid?result['latitude'] as double:double.tryParse(result['latitude'] as String);
          if(latitude!=null && longitude!=null){
            var w84=XDLatLngTransformUtil.gcj02ToGps84(LatLng(latitude, longitude));
            lastPosition=XDLocation(
                latitude: w84.latitude,
                longitude: w84.longitude);
            streamController.add(lastPosition!);

          }
        }

   });


     _setLocationOption();
     _locationPlugin.startLocation();
   inited=true;
    return true;
  }


  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption =  AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = false;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode = AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 5000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  @override
  XDLocation? getLastPosition() {
    return lastPosition;
  }

}
