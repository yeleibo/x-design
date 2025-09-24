import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
///地图搜索
class XDMapSearchController extends   ChangeNotifier {
  ///points的个数时1时代表点查询，打印1代表范围查询
  Future<List<MapSearchResult>>  Function({String? keyword,List<LatLng>? points}) searchFunction;
  ///地图控制器
  MapController mapController;
  ///搜索结果
  List<MapSearchResult> searchResult;
  ///结果被选中的index
  int? searchResultSelectedIndex;

  MapSearchResult? get selectedResult=>searchResultSelectedIndex==null?null:searchResult[searchResultSelectedIndex!];
  XDMapSearchController({required this.mapController,required this.searchFunction}):searchResult=[]{
    ///处理地图点击事件搜索事件
    mapController.mapEventStream.listen((event) {
      if(event is MapEventTap){
        searchByLatLng(event.tapPosition);
      }
    });
  }
  ///通过关键字搜索
  Future<FutureOr<void>> searchByKeyword(String keyword) async {
    //判断关键字是经纬度
    RegExp endRegexp = RegExp("([0-9]+([.]{1}[0-9]+){0,1})\$");
    RegExpMatch? endMatch = endRegexp.firstMatch(keyword);

    RegExp firstRegexp = RegExp("^([0-9]+([.]{1}[0-9]+){0,1})");
    RegExpMatch? firstMatch = firstRegexp.firstMatch(keyword);
    if(endMatch!=null && firstMatch!=null && firstMatch.group(0)!=endMatch.group(0)){
      //是经纬度就地图就直接跳转过去
      var firstValue=double.parse(firstMatch.group(0)!);
      var endValue=double.parse(endMatch.group(0)!);
      searchByLatLng(LatLng(firstValue, endValue));
      mapController.move(LatLng(firstValue, endValue), mapController.camera.zoom);
      return null;
    }else{
      //不是经纬度就通过关键字搜索
      searchResult=await searchFunction(keyword:keyword);
      searchResultSelectedIndex=(searchResult.isNotEmpty) ?0:null;
      if(selectedResult!=null){
        mapController.move(selectedResult!.points.first, mapController.camera.zoom);
      }
      notifyListeners();
    }

  }
  ///通过经纬度搜索
  Future<void> searchByLatLng(LatLng latLng) async {

    searchResult=await searchFunction(points:[latLng]);
    searchResultSelectedIndex=(searchResult.isNotEmpty) ?0:null;
    if(selectedResult!=null){
      mapController.move(selectedResult!.points.first, mapController.camera.zoom);
    }
    notifyListeners();
  }

  ///清除搜索结果
  void clearSearchResult(){
    searchResult=[];
    searchResultSelectedIndex=null;
    notifyListeners();
  }

  void changeSelectedResult(MapSearchResult result){
    searchResultSelectedIndex=searchResult.indexOf(result);
    mapController.move(result.points.first, mapController.camera.zoom);
    notifyListeners();
  }

}

///搜索结果对象
class MapSearchResult{
  String? layerName;
  int? id;
  String name;
  ///代表是点-》“point”还是线->'polygon',地址-》‘address’,
  String type;
  List<LatLng> points;
  List<LatLng>?  pointsAll;
  Map<String,String> attributes;
  int? projectId;
  MapSearchResult({this.id,required this.name,required this.type, this.layerName, this.attributes=const{}, this.points=const[],this.pointsAll,this.projectId});

  ///解析json转换成对象
  factory MapSearchResult.fromJson(Map<String, dynamic> json) =>
     MapSearchResult(      id: json['id'] as int,
       name: json['name'] as String,
       type: json['type'] as String,
       layerName: json['layerName'] as String,
       attributes: (json['attributes'] as Map<String, dynamic>?)?.map(
             (k, e) => MapEntry(k, e as String),
       ) ??
           const {},
       points: (json['points'] as List<dynamic>?)
           ?.map((e) => LatLng((e as Map<String, dynamic>)['lat'], (e)['lon']))
           .toList() ??
           const [],
       pointsAll: (json['points'] as List<dynamic>?)
           ?.map((e) => LatLng((e as Map<String, dynamic>)['lat'], (e)['lon']))
           .toList() ??
           const [],
     );
  
  ///图层类型
  String get layerType{
    switch (layerName) {
      case '前端机房':
        return 'room';
      case '箱体设备':
        return 'opticbox';
      case '接续盒':
        return 'opticjump';
      case '光缆':
        return 'opticfiber';
      case '住宅楼':
        return 'building';
      case '管道':
        return 'duct';
      case '管井':
        return 'ductwell';
      default:
        return 'unknow';
    }
  }
}