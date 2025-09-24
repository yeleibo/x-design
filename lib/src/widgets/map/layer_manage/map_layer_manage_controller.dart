import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../xd_design.dart';

///图层管理器
///XDMapLayersManageController(allLayers: [
///           MapLayer(name: "基础图层", code: "baseMap",children: [
///             MapLayer(name: "高德", code: 'gaode',isShow:false),
///             MapLayer(name: "高德2", code: 'gaode2',isShow:false)
///           ])
///         ])

var baseMapsWithInChina = MapLayer(name: "基础图层", code: "baseMap", children: [
  MapLayer(
      name: "高德标准",
      code: 'gaodeStand',
      isShow: true,
      tileLayer: XDMapBaseLayer.gaodeStandardMapLayer,
      icon: XDImageWidget(
        isRadius: false,
        imagePath: 'assets/images/map/base_layer/stand.png',
        package: 'x_design',
      )),
  MapLayer(
      name: "高德卫星",
      code: 'gaodeSatellite',
      isShow: false,
      tileLayer: XDMapBaseLayer.gaodeSatelliteMapLayer,
      icon: XDImageWidget(
        isRadius: false,
        imagePath: 'assets/images/map/base_layer/satellite.png',
        package: 'x_design',
      )),
  MapLayer(
      name: "天地图标准",
      code: 'tiandituStand',
      isShow: false,
      tileLayer: XDMapBaseLayer.tiandituStandardMapLayer,
      icon: XDImageWidget(
        isRadius: false,
        imagePath: 'assets/images/map/base_layer/stand.png',
        package: 'x_design',
      )),
  MapLayer(
      name: "天地图卫星",
      code: 'tiandituSatellite',
      isShow: false,
      tileLayer: XDMapBaseLayer.tiandituSatelliteMapLayer,
      icon: XDImageWidget(
        isRadius: false,
        imagePath: 'assets/images/map/base_layer/satellite.png',
        package: 'x_design',
      )),
]);
var baseMapsWithOutChina = MapLayer(name: "layers", code: "baseMap", children: [
  MapLayer(
      name: "google stand",
      code: 'googleStand',
      isShow: true,
      icon: XDImageWidget(
        isRadius: false,
        imagePath: 'assets/images/map/base_layer/stand.png',
        package: 'x_design',
      )),
  MapLayer(
      name: "google satellite",
      code: 'googleSatellite',
      isShow: false,
      icon: XDImageWidget(
        isRadius: false,
        imagePath: 'assets/images/map/base_layer/satellite.png',
        package: 'x_design',
      ))
]);

class XDMapLayersManageController extends ChangeNotifier {
  ///所有的图层
  final List<MapLayer> allLayers;

  ///所有的图层放到一维数组中
  List<MapLayer> allLayersWithOneDimensional = [];

  ///基础图层
  MapLayer? get baseMapLayer => allLayersWithOneDimensional
      .where((element) =>
          getParentMapLayer(element)?.code == "baseMap" && element.isShow)
      .singleOrNull;

  XDMapLayersManageController({required this.allLayers}) {
    for (var item in allLayers) {
      _splitLayers(item);
    }
  }

  ///拆分图层，将多维变成一维
  void _splitLayers(MapLayer layer) {
    allLayersWithOneDimensional.add(layer);
    if (layer.children != null) {
      for (var element in layer.children!) {
        _splitLayers(element);
      }
    }
  }

  ///获取父图层
  MapLayer? getParentMapLayer(MapLayer mapLayer) {
    return allLayersWithOneDimensional
        .where((element) => element.children?.contains(mapLayer) == true)
        .singleOrNull;
  }

  void changeLayer(MapLayer mapLayer) {
    //多级结构时再优化
    if (getParentMapLayer(mapLayer)?.code == "baseMap") {
      //只能有一个基础图层
      var otherBaseMaps = allLayersWithOneDimensional.where((element) =>
          getParentMapLayer(mapLayer)?.code == "baseMap" &&
          element != mapLayer);
      for (var otherBaseMap in otherBaseMaps) {
        otherBaseMap.isShow = false;
      }
      mapLayer.isShow = true;
    }
    notifyListeners();
  }
}

///地图图层,code为baseMap的是特殊图层
class MapLayer {
  ///图层名称
  final String name;
  final String code;
  final Widget? icon;

  ///在自定义图层里使用
  final TileLayer? tileLayer;

  ///是否展示
  bool isShow;
  List<MapLayer>? children;
  MapLayer(
      {required this.name,
      required this.code,
      this.children,
      this.isShow = true,
      this.icon,
      this.tileLayer});
}
