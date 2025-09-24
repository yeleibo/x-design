import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:x_design/src/core/global.dart';

///对地图做进一步的封装
class XDMap extends StatelessWidget {
  ///地图控制器，如何需要使用带动画的控制器可以使用flutter_map_animations
  final MapController? mapController;

  ///地图的children
  final List<Widget> children;

  ///地图配置
  ///禁止旋转 interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate)
  final MapOptions options;

  XDMap(
      {super.key,
      this.mapController,
      required this.children,
      MapOptions? options})
      : options = options ?? XDMap.defaultMapOptions();

  @override
  Widget build(BuildContext context) {
    // mapController?.mapEventStream.listen((event) {
    //   print(mapController?.camera?.zoom);
    // });
    return FlutterMap(
      mapController: mapController,
      options: options,
      children: children,
    );
  }

  ///默认的交互选项
  static InteractionOptions defaultInteractionOptions() {
    var flags = (InteractiveFlag.all & ~InteractiveFlag.rotate);
    if (isDesktop) {
      ///桌面端禁用双击放大，不然会影响滑动体验
      flags = flags & ~InteractiveFlag.doubleTapZoom;
    }
    return InteractionOptions(flags: flags);
  }

  ///简单地图选项
  static MapOptions defaultMapOptions(
          {LatLng initialCenter = const LatLng(30.456, 114.3),
          double initialZoom = 13}) =>
      MapOptions(
          //禁用旋转
          interactionOptions: defaultInteractionOptions(),
          initialCenter: initialCenter,
          initialZoom: initialZoom,
          //最大的放大等级
          maxZoom: double.maxFinite,
          minZoom: 2);
}

///地图底图
class XDMapBaseLayer {
  // static List<TileLayer> mapBaseLayerFromCode(
  //     String mapCode, XDMapTypeEnum type) {
  //   switch (mapCode) {
  //     default:
  //       return tiandituStandardMapLayer;
  //   }
  // }

  ///m：路线图 lyrs的值 t：地形图  p：带标签的地形图s：卫星图y：带标签的卫星图h：标签层（路名、地名等）
  //谷歌矢量：
  // https://blog.csdn.net/GISuuser/article/details/83089467?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522007a4fb52c6857f5cb03f10256768bc5%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=007a4fb52c6857f5cb03f10256768bc5&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-9-83089467-null-null.142^v102^pc_search_result_base4&utm_term=google.com%2Fvt&spm=1018.2226.3001.4187
  ///谷歌标准地图
  static TileLayer get googleStandardMapLayer => TileLayer(
        tileProvider: FMTCTileProvider(
            stores: {"GoogleStandard": BrowseStoreStrategy.readUpdateCreate},
            loadingStrategy: BrowseLoadingStrategy.onlineFirst),
        urlTemplate: 'http://{s}.google.com/vt/lyrs=m@189&x={x}&y={y}&z={z}',
        maxNativeZoom: 20,
        subdomains: ["mt0", "mt1", "mt2", "mt3"],
      );

  ///谷歌卫星地图
  static TileLayer get googleSatelliteMapLayer => TileLayer(
        tileProvider: FMTCTileProvider(
            stores: {"GoogleSatellite": BrowseStoreStrategy.readUpdateCreate},
            loadingStrategy: BrowseLoadingStrategy.onlineFirst),
        urlTemplate: 'http://{s}.google.com/vt/lyrs=y@113&x={x}&y={y}&z={z}',
        maxNativeZoom: 20,
        subdomains: ["mt0", "mt1", "mt2", "mt3"],
      );

  ///高德标准地图
  static TileLayer get gaodeStandardMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'http://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
        maxNativeZoom: 18,

      );

  ///高德卫星地图
  static TileLayer get gaodeSatelliteMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'https://webst01.is.autonavi.com/appmaptile?lang=zh_cn&style=6&x={x}&y={y}&z={z}',
        maxNativeZoom: 18,
      );

  ///高德地标地图
  static TileLayer get gaodeLabelMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'https://wprd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=8&x={x}&y={y}&z={z}&scl=1&ltype=4',
        maxNativeZoom: 18,
      );

  ///高德道路地图
  static TileLayer get gaodeRoadMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'https://webst01.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scale=1&style=8',
        maxNativeZoom: 18,
      );

  ///天地图标准地图
  static TileLayer get tiandituStandardMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'http://{s}.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=782cfa7e1b12cd72e0a3a8f09ab54f38',
        maxNativeZoom: 18,
        subdomains: ['t0', 't1', 't2', 't3', 't4', 't5', 't6', 't7'],
      );

  ///天地图卫星地图
  static TileLayer get tiandituSatelliteMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'http://{s}.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=782cfa7e1b12cd72e0a3a8f09ab54f38',
        maxNativeZoom: 18,
        subdomains: ['t0', 't1', 't2', 't3', 't4', 't5', 't6', 't7'],
      );

  ///天地图路网地图
  static TileLayer get tiandituLabelMapLayer => TileLayer(
        tileProvider: NetworkTileProvider(),
        urlTemplate:
            'http://{s}.tianditu.gov.cn/cva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=782cfa7e1b12cd72e0a3a8f09ab54f38',
        maxNativeZoom: 18,
        subdomains: ['t0', 't1', 't2', 't3', 't4', 't5', 't6', 't7'],
      );

  ///OSM地图
  static TileLayer get openstreetMapLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        maxNativeZoom: 20,
      );
}

enum XDMapTypeEnum {
  //卫星地图
  satellite,
  //标准
  standard;

  @override
  String toString() {
    switch (this) {
      case satellite:
        return 'Satellite';
      case standard:
        return 'Standard';
    }
  }
}
