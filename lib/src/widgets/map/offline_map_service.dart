import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:x_design/xd_design.dart';

class OfflineMapService {
  static const String _mapsKey = 'offline_maps_list';

  // 以 mapId 为 key 管理下载控制器
  final Map<String, DownloadController> _downloadControllers = {};

  bool isInitialized = false;
  // 单例
  static final OfflineMapService _instance = OfflineMapService._internal();
  factory OfflineMapService() => _instance;
  OfflineMapService._internal();


  Future<void> init() async {
    await FMTCObjectBoxBackend().initialise();
    var store = FMTCStore("GoogleStandard");
    await store.manage.create();
    var store2 = FMTCStore("GoogleSatellite");
    await store2.manage.create();

  }

  Future<void> saveDownloadedMap(OfflineMapInfo mapInfo) async {
    final maps = await getDownloadedMaps();
    maps.add(mapInfo);
    await _saveMapsList(maps);
  }

  Future<List<OfflineMapInfo>> getDownloadedMaps() async {
    final mapsJson = dataCacheService.getDataByDataName<List>(_mapsKey);
    if (mapsJson != null && mapsJson is List) {
      return mapsJson
          .map((e) => OfflineMapInfo.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<List<OfflineMapInfo>> getDownloadedMapsByMapCode(String mapCode) async {
    final allMaps = await getDownloadedMaps();
    return allMaps.where((map) => map.mapCode == mapCode).toList();
  }

  Future<void> deleteMap(String mapId, String mapCode) async {
    final maps = await getDownloadedMaps();
    maps.removeWhere((map) => map.id == mapId && map.mapCode == mapCode);
    await _saveMapsList(maps);

    final store = FMTCStore(mapCode);
    if (await store.manage.ready) {
      await store.manage.delete();
    }
  }

  Future<void> _saveMapsList(List<OfflineMapInfo> maps) async {
    final mapsJson = maps.map((e) => e.toJson()).toList();
    await dataCacheService.saveData(_mapsKey, mapsJson);
  }

  TileProvider getTileProvider(String mapCode) {
    // Create the tile provider using the store instance
    return FMTCTileProvider(
      stores: {
        mapCode: BrowseStoreStrategy.readUpdateCreate,
      },
    );
  }
  


  /// 启动前台下载（绑定 instanceId = mapId，便于后续 pause/resume/cancel 精确控制）
  Future<DownloadController> downloadMapTiles({
    required String mapId,
    required String mapStoreName,
    required String mapCode,
    required String mapName,
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
    required TileLayer tileLayerOptions,
    required void Function(DownloadProgress) onProgress,
    required VoidCallback onComplete,
    required void Function(Object error) onError,
  }) async {

    final store = FMTCStore(mapStoreName);


    
    if (!await store.manage.ready) {
      await store.manage.create();
    } else {
    }

    final region = RectangleRegion(bounds);
    final downloadableRegion = region.toDownloadable(
      minZoom: minZoom,
      maxZoom: maxZoom,
      options: tileLayerOptions,
    );

    // 使用 instanceId = mapId（strings 具备合适的 ==/hashCode）
    final (:downloadProgress, :tileEvents) = store.download.startForeground(
      region: downloadableRegion,
      parallelThreads: 10,
      maxBufferLength: 100,
      skipExistingTiles: true,
      skipSeaTiles: true,
      instanceId: mapId, // ★★★ 关键
    );

    final controller = DownloadController(
      mapId: mapId,
      mapCode: mapCode,
      instanceId: mapId,
      store: store,
      region: downloadableRegion,
      minZoom: minZoom,
      maxZoom: maxZoom,
      bounds: bounds,
      mapName: mapName,
    );

    controller.progressSubscription = downloadProgress.listen(
          (progress) {
        controller.lastProgress = progress;
        print('OfflineMapService: Download progress - ${progress.percentageProgress.toStringAsFixed(1)}%');
        onProgress(progress);
      },
      onError: (err, st) {
        print('OfflineMapService: Download error: $err');
        onError(err);
      },
      onDone: () async {
        try {
          _downloadControllers.remove(mapId);

          final sizeInMB = await _getStoreSizeInMB(mapCode, mapId);
          print('OfflineMapService: Download complete for $mapCode, size: ${sizeInMB.toStringAsFixed(2)} MB');
          
          final mapInfo = OfflineMapInfo(
            id: mapId,
            mapCode: mapCode,
            name: mapName,
            bounds: bounds,
            downloadDate: DateTime.now(),
            sizeInMB: sizeInMB,
            minZoom: minZoom,
            maxZoom: maxZoom,
          );
          await saveDownloadedMap(mapInfo);
          onComplete();
        } catch (e) {
          print('OfflineMapService: Error saving downloaded map info: $e');
          onError(e);
        }
      },
    );

    controller.tileEventsSubscription = tileEvents.listen(
          (_) {},
      onError: (err, st) => onError(err),
    );

    _downloadControllers[mapId] = controller;
    return controller;
  }

  // 统计大小（KiB -> MiB）
  Future<double> _getStoreSizeInMB(String mapCode, String mapId) async {
    final stats = FMTCStore(mapCode).stats;
    final kib = await stats.size;
    return kib / 1024.0;
  }

  Future<bool> isMapDownloaded(String mapId) async {
    final maps = await getDownloadedMaps();
    return maps.any((map) => map.id == mapId);
  }


  
  /// 暂停下载（真正使用 pause，而不是 cancel）
  Future<bool?> pauseDownload(String mapId) async {
    final c = _downloadControllers[mapId];
    if (c == null) return false;
    return c.store.download.pause(instanceId: c.instanceId);
  }

  /// 恢复下载（同一实例）
  Future<bool?> resumeDownload(String mapId) async {
    final c = _downloadControllers[mapId];
    if (c == null) return false;
    return c.store.download.resume(instanceId: c.instanceId);
  }

  /// 停止下载（彻底取消）
  Future<void> stopDownload(String mapId) async {
    final c = _downloadControllers[mapId];
    if (c != null) {
      await c.store.download.cancel(instanceId: c.instanceId);
      await c.progressSubscription?.cancel();
      await c.tileEventsSubscription?.cancel();
      _downloadControllers.remove(mapId);
    }
  }

  bool isDownloading(String mapId) => _downloadControllers.containsKey(mapId);

  /// 直接问底层下载是否处于暂停态
  bool isPaused(String mapId) {
    final c = _downloadControllers[mapId];
    if (c == null) return false;
    return c.store.download.isPaused(instanceId: c.instanceId);
  }
}

class DownloadController {
  final String mapId;
  final String mapCode;
  final Object instanceId; // 与 mapId 相同，用于区分下载实例
  final FMTCStore store;
  final DownloadableRegion<BaseRegion> region;
  final int minZoom;
  final int maxZoom;
  final LatLngBounds bounds;
  final String mapName;

  DownloadProgress? lastProgress;
  StreamSubscription<DownloadProgress>? progressSubscription;
  StreamSubscription<TileEvent>? tileEventsSubscription;

  DownloadController({
    required this.mapId,
    required this.mapCode,
    required this.instanceId,
    required this.store,
    required this.region,
    required this.minZoom,
    required this.maxZoom,
    required this.bounds,
    required this.mapName,
  });
}

class OfflineMapInfo {
  final String id;
  final String mapCode;
  final String name;
  final LatLngBounds bounds;
  final DateTime downloadDate;
  final double sizeInMB;
  final int minZoom;
  final int maxZoom;

  OfflineMapInfo({
    required this.id,
    required this.mapCode,
    required this.name,
    required this.bounds,
    required this.downloadDate,
    required this.sizeInMB,
    required this.minZoom,
    required this.maxZoom,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mapCode': mapCode,
      'name': name,
      'north': bounds.north,
      'south': bounds.south,
      'east': bounds.east,
      'west': bounds.west,
      'downloadDate': downloadDate.toIso8601String(),
      'sizeInMB': sizeInMB,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
    };
  }

  factory OfflineMapInfo.fromJson(Map<String, dynamic> json) {
    return OfflineMapInfo(
      id: json['id'],
      mapCode: json['mapCode'] ?? 'default',
      name: json['name'],
      bounds: LatLngBounds(
        LatLng(json['south'], json['west']),
        LatLng(json['north'], json['east']),
      ),
      downloadDate: DateTime.parse(json['downloadDate']),
      sizeInMB: (json['sizeInMB'] as num).toDouble(),
      minZoom: json['minZoom'] ?? 10,
      maxZoom: json['maxZoom'] ?? 18,
    );
  }
}
