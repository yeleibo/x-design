import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../xd_design.dart';

class XDDrawActionLayer extends StatelessWidget {
  final XDDrawPointsController mapPointsController;

  ///重置
  final Function(List<LatLng> points)? onReset;

  ///撤销
  final Function(List<LatLng> points)? onUndo;

  final double top;
  final AlignmentGeometry alignment;
  const XDDrawActionLayer({
    super.key,
    required this.mapPointsController,
    this.onReset,
    this.onUndo,
    this.alignment = Alignment.topRight,
    this.top = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, top, 10, 10),
        child: ChangeNotifierProvider.value(
          value: mapPointsController,
          child: Consumer<XDDrawPointsController>(
            builder: (context, mapPointsController, child) {
              return RawKeyboardListener(
                focusNode: mapPointsController.focusNode,
                onKey: (event) {
                  if (event is RawKeyDownEvent) {
                    bool isControlPressed =
                        event.isControlPressed; // Check if CTRL is pressed
                    if (isControlPressed &&
                        event.logicalKey == LogicalKeyboardKey.keyZ) {
                      mapPointsController.undoPoint();
                    }
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    XDMapActionLayer(
                        iconWidget: const Icon(Icons.restart_alt_rounded),
                        text: Text(
                          XDLocalizations.of(context).reset,
                          style: const TextStyle(fontSize: 10),
                        ),
                        onTap: () {
                          mapPointsController.clearPoints();
                          onReset?.call(mapPointsController.points);
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    XDMapActionLayer(
                        iconWidget: const Icon(Icons.undo_outlined),
                        text: Text(
                          XDLocalizations.of(context).undo,
                          style: const TextStyle(fontSize: 10),
                        ),
                        onTap: () {
                          mapPointsController.undoPoint();
                          onReset?.call(mapPointsController.points);
                        }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
