import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class XDDrawPointsController extends ChangeNotifier {
  final MapController mapController;

  /// 当前是否允许编辑
  bool isEdit;

  /// 已绘制的点
  List<LatLng> points;

  /// 撤销后暂存的点，用于恢复
  final List<LatLng> _redoStack = [];

  /// 外部监听
  final Function(List<LatLng> points)? onChange;

  final FocusNode focusNode = FocusNode();

  /* ---------- 对外 API ---------- */

  /// 用一批新点整体替换
  void changePoints(List<LatLng> newPoints) {
    points = newPoints;
    _redoStack.clear(); // 替换后无法再 redo
    notifyListeners();
  }

  /// 撤销最后一个点
  void undoPoint() {
    if (points.isNotEmpty) {
      _redoStack.add(points.removeLast());
      notifyListeners();
    }
  }

  /// 恢复上一次撤销的点
  void restorePoint() {
    if (_redoStack.isNotEmpty) {
      points.add(_redoStack.removeLast());
      notifyListeners();
    }
  }

  /// 清空全部
  void clearPoints() {
    points.clear();
    _redoStack.clear();
    notifyListeners();
  }

  /// 开／关编辑
  void changeEdit(bool isEdit) {
    this.isEdit = isEdit;
    notifyListeners();
  }

  /* ---------- 构造 & 监听 ---------- */

  XDDrawPointsController({
    required this.mapController,
    this.onChange,
    this.isEdit = true,
    List<LatLng>? points,
  }) : points = points ?? [] {
    mapController.mapEventStream.listen((event) {
      if (!isEdit) return;

      // 只处理点击
      if (event is MapEventTap) {
        focusNode.requestFocus();

        // 加新点 → redo 记录失效
        this.points.add(event.tapPosition);
        _redoStack.clear();

        onChange?.call(this.points);
        notifyListeners();
      }
    });
  }
}
