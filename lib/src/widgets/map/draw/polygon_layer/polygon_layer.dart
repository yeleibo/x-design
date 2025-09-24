import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../../xd_design.dart';

///多边形框选图层
class XDDrawPolygonLayer extends StatefulWidget {
  final XDDrawPointsController mapPointsController;
  ///线条颜色
  final Color lineColor;
  final Function(List<LatLng> points)? onChange;
  const XDDrawPolygonLayer({
    super.key,
    required this.mapPointsController,
    this.onChange,
    this.lineColor = Colors.green,
  });

  @override
  State<XDDrawPolygonLayer> createState() => _XDDrawPolygonLayerState();
}

class _XDDrawPolygonLayerState extends State<XDDrawPolygonLayer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.mapPointsController,
      child: Consumer<XDDrawPointsController>(
        builder: (_, mapPointsController, child) {
          Widget myStartChild;
          if (mapPointsController.points.length == 1) {
            myStartChild = markerLayer(mapPointsController.points,widget.lineColor);
          } else if (mapPointsController.points.length == 2) {
            myStartChild = polylineLayer(mapPointsController.points,widget.lineColor);
          } else if (mapPointsController.points.length > 2) {
            myStartChild = polygonLayer(mapPointsController.points,widget.lineColor);
          } else {
            myStartChild = const SizedBox();
          }
          return myStartChild;
        },
      ),
    );
  }
}

Widget markerLayer(List<LatLng> points,Color lineColor) {
  return MarkerLayer(
    markers: [
      Marker(
          point: points.first,
          width: 10,
          height: 10,
          child: Container(
            decoration: BoxDecoration(
                color: lineColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          )),
    ],
  );
}

Widget polylineLayer(List<LatLng> points,Color lineColor) {
  return PolylineLayer(
    polylines: [
      Polyline(
        points: points,
        color: lineColor,
        strokeWidth: 3,
      ),
    ],
  );
}

Widget polygonLayer(List<LatLng> points,Color lineColor) {
  return PolygonLayer(
    polygons: [
      Polygon(
        points: points,
        color: Colors.green.withOpacity(0.8),
        borderColor: lineColor,
        borderStrokeWidth: 3,
      ),
    ],
  );
}
