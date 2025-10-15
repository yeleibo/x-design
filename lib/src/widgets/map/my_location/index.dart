
export 'my_location_controller.dart';
export 'my_position_latlng_layer.dart';
export 'my_postion_mark_layer.dart';
export 'my_location_move_to_map_center_action_layer.dart';


import 'package:flutter/widgets.dart';
import 'my_location_controller.dart';
import 'my_location_move_to_map_center_action_layer.dart';
import 'my_position_latlng_layer.dart';
import 'my_postion_mark_layer.dart';



///我的位置图层组
List<Widget> myPositionLayerGroups(
    {required XDMyLocationController myLocationController}) {
  return [
    ///我显示在地图上的位置
    XDMyPositionLatLngLayer(myLocationController: myLocationController),
    XDMyPositionMarkLayer(myLocationController: myLocationController),
    XDMyLocationMoveToMapCenterActionLayer(myLocationController: myLocationController),
  ];
}


