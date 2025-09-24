import 'package:location/location.dart';
import 'package:x_design/xd_design.dart';


///国外的推荐
class LocationServiceImplementByLocation  with LocationBase implements LocationService{
  XDLocation? _lastLocation;
  bool _serviceEnabled=false;
  PermissionStatus? _permissionGranted;
  @override
  Future<bool> init() async {
    Location location =  Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    location.onLocationChanged.listen((event) {
      if(event.latitude!=null && event.longitude!=null){
        _lastLocation=_transfer(event);
        streamController.add(_lastLocation!);
      }
    });
    return true;
  }


  XDLocation _transfer(LocationData locationData){
    return XDLocation(latitude:locationData.latitude!,longitude: locationData.longitude!,altitude: locationData.altitude );
  }

  @override
  XDLocation? getLastPosition() {
    return _lastLocation;
  }
}