import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_design/src/widgets/map/index.dart';

class XDMapBaseMapLayer extends StatelessWidget {
  final XDMapLayersManageController layersManageController;
  const XDMapBaseMapLayer({super.key,required this.layersManageController});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: layersManageController,child: Consumer<XDMapLayersManageController>(builder: (BuildContext context, XDMapLayersManageController value, Widget? child) {
      var baseMap=layersManageController.baseMapLayer;
      var layer=baseMap?.tileLayer;
      if(baseMap!=null && layer==null){
        var mapCode=baseMap.code.toLowerCase();
        if(mapCode.contains("gaode") ){
          return mapCode.contains("stand")?XDMapBaseLayer.gaodeStandardMapLayer:XDMapBaseLayer.gaodeSatelliteMapLayer;
        }
        if(mapCode.contains("tianditu") ){
          return mapCode.contains("stand")?XDMapBaseLayer.tiandituStandardMapLayer:XDMapBaseLayer.tiandituSatelliteMapLayer;
        }
        if(mapCode.contains("google") ){
          return mapCode.contains("stand")?XDMapBaseLayer.googleStandardMapLayer:XDMapBaseLayer.googleSatelliteMapLayer;
        }
      }
      return layer??SizedBox();
    },),);
  }
}

///地图地图标记图层，如路网信息等
class XDMapBaseMapLabelLayer extends StatelessWidget {
  final XDMapLayersManageController layersManageController;
  const XDMapBaseMapLabelLayer({super.key,required this.layersManageController});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: layersManageController,child: Consumer<XDMapLayersManageController>(builder: (BuildContext context, XDMapLayersManageController value, Widget? child) {
      var baseMap=layersManageController.baseMapLayer;

        var mapCode=baseMap?.code.toLowerCase();
        if(mapCode?.contains("gaode")==true && mapCode?.contains("stand")==true ){
          return XDMapBaseLayer.gaodeLabelMapLayer;
        }
        if(mapCode?.contains("tianditu")==true ){
          return XDMapBaseLayer.tiandituLabelMapLayer;
        }

      return SizedBox();
    },),);
  }
}
