import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
class LatlongJsonConverter extends JsonConverter<LatLng, Map<String,dynamic>>{
  const LatlongJsonConverter();
  @override
  LatLng fromJson(Map<String, dynamic> json) {
    return LatLng(json['lat'], json['lon']);
  }

  @override
  Map<String, dynamic> toJson(LatLng object) {
    return {
      'lat':object.latitude,
      'lon':object.longitude
    };
  }


}