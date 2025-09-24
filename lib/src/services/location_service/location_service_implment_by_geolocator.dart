import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:x_design/xd_design.dart';


class LocationServiceImplementByGeolocator with LocationBase implements LocationService {
  XDLocation? _lastLocation;
  XDLocation? _currentPosition;

  @override
  Future <XDLocation> getCurrentPosition() async {
    var locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    var w84=XDLatLngTransformUtil.gcj02ToGps84(LatLng(position.latitude, position.longitude));
    _currentPosition=XDLocation(
        latitude: w84.latitude,
        longitude: w84.longitude);
    return _currentPosition!;
  }
  @override
  Future<bool> init() async {
    var serviceEnabled =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('位置服务被禁用.');
    }

    var permission = await GeolocatorPlatform.instance.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await GeolocatorPlatform.instance.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('位置权限被拒绝');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          '位置权限被永久拒绝，我们不能要求许可.');
    }

    late LocationSettings locationSettings;
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        forceLocationManager: true,
      );
    } else {
      locationSettings = const LocationSettings();
    }
    GeolocatorPlatform.instance.getPositionStream(locationSettings:locationSettings ).listen((event) {
      streamController.add(XDLocation(latitude: event.latitude, longitude: event.longitude,altitude: event.altitude));
      var w84=XDLatLngTransformUtil.gcj02ToGps84(LatLng(event.latitude, event.longitude));
      _lastLocation=XDLocation(
          latitude: w84.latitude,
          longitude: w84.longitude);
    });
    return true;
  }



  @override
  XDLocation? getLastPosition() {
    return _lastLocation;
  }
}
