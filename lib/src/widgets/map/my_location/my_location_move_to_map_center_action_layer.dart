import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_design/xd_design.dart';
import 'my_location_controller.dart';

///我的位置移动到地图中心动作图层
class XDMyLocationMoveToMapCenterActionLayer extends StatelessWidget {
  final XDMyLocationController myLocationController;
  const XDMyLocationMoveToMapCenterActionLayer({super.key,required this.myLocationController, });

  @override
  Widget build(BuildContext context) {
    return  Align(alignment: Alignment.bottomRight,child: ChangeNotifierProvider.value(
        value: myLocationController,
        child: Selector<XDMyLocationController, bool>(
        builder: (context, isAutoMoveToMapCenter, child) {
          return Container(margin: EdgeInsets.only(bottom: 15,right: 15),
          child: XDMapActionLayer(onTap: (){
            myLocationController.changeAutoMoveToMapCenter();
          },iconWidget:
          Icon(
            Icons.my_location,
            color: isAutoMoveToMapCenter
                ? Colors.blueAccent
                : Colors.grey.shade500,
          ),
            text: Text(XDLocalizations.of(context).location,),
          ),);
        } ,
      selector: (context, controller) => controller.isAutoMoveToMapCenter,)));

  }
}
