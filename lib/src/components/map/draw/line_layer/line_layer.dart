import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../../xd_design.dart';

///线图层
class XDDrawLineLayer extends StatefulWidget {
  final XDDrawPointsController mapPointsController;
  final Function(List<LatLng> points)? onChange;

  ///线条颜色
  final Color lineColor;
  //默认闭合
  final bool isClose;
  final String layerCode;
  const XDDrawLineLayer({
    super.key,
    required this.mapPointsController,
    this.onChange,
    this.isClose = true,
    this.lineColor = Colors.green,
    required this.layerCode,
  });

  @override
  State<XDDrawLineLayer> createState() => _XDDrawLineLayerState();
}

class _XDDrawLineLayerState extends State<XDDrawLineLayer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.mapPointsController,
      child: Consumer<XDDrawPointsController>(
        builder: (_, mapPointsController, child) {
          switch (mapPointsController.points.length) {
            case 0:
              return const SizedBox();
            case 1:
              return markerLayer(mapPointsController.points,widget.lineColor);
            case 2:
              return polylineLayer(mapPointsController.points,widget.lineColor);
            default:
              return widget.isClose
                  ? polygonLayer(mapPointsController.points,widget.lineColor)
                  : polylineLayer(mapPointsController.points,widget.lineColor);
          }
        },
      ),
    );
  }
}
