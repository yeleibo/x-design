import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:provider/provider.dart';

import '../../../../../xd_design.dart';

class XDDragLayer extends StatefulWidget {
  final XDDrawPointsController mapPointsController;

  const XDDragLayer({super.key, required this.mapPointsController});

  @override
  State<XDDragLayer> createState() => _XDDragLayerState();
}

class _XDDragLayerState extends State<XDDragLayer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.mapPointsController,
        child: Consumer<XDDrawPointsController>(
          builder: (context, mapPointsController,child) {
           var polyEditor = PolyEditor(
              points: widget.mapPointsController.points,
              pointIcon: const Icon(Icons.crop_square, size: 18),
              addClosePathMarker: true,
            );
            return DragMarkers(markers: polyEditor.edit());
          },
        ));
  }
}
