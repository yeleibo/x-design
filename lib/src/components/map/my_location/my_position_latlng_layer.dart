import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:x_design/l10n/intl/xd_localizations.dart';
import 'my_location_controller.dart';

///在地图上我的位置的经纬度文字图层
class XDMyPositionLatLngLayer extends StatelessWidget {
  final XDMyLocationController myLocationController;
  final Color? color;
  const XDMyPositionLatLngLayer(
      {super.key,
      required this.myLocationController,
      this.color = Colors.blueAccent,});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: ChangeNotifierProvider.value(
          value: myLocationController,
          child: Selector<XDMyLocationController, LatLng?>(
            builder: (context, myPosition, child) {
              return myPosition == null
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "${XDLocalizations.of(context).myPosition}:${formateFromW84ToOther(myLocationController.mapCode, myPosition).latitude.toStringAsFixed(6)},${formateFromW84ToOther(myLocationController.mapCode, myPosition).longitude.toStringAsFixed(6)}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ));
            },
            selector: (context, controller) => controller.myPosition,
          ),
        ));
  }
}
