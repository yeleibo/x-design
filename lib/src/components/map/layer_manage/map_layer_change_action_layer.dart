import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_design/xd_design.dart';

import '../map_action_layer.dart';
import 'map_layer_manage_controller.dart';

class XDMapLayerChangeActionLayer extends StatelessWidget {
  final XDMapLayersManageController layersManageController;
  final double top;
  final AlignmentGeometry alignment;
  const XDMapLayerChangeActionLayer({
    super.key,
    required this.layersManageController,
    this.alignment = Alignment.topRight,
    this.top = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, top, 10, 0),
          child: XDMapActionLayer(
            onTap: () {
              showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: layersManageController,
                      child: Consumer<XDMapLayersManageController>(
                          builder: (_, layersManageController, child) {
                        return Dialog(
                            alignment: Alignment.topRight,
                            insetPadding: EdgeInsets.zero,
                            child: SizedBox(
                              width: isDesktop ? 800 : 300,
                              child: Drawer(
                                ///edit start
                                child: ListView(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        MediaQuery.of(context).padding.top + 10,
                                        0,
                                        0),
                                    children: layersManageController.allLayers
                                        .map((e) {
                                      return ExpandablePanel(
                                          controller: ExpandableController(
                                              initialExpanded:
                                                  e.code == "baseMap"),
                                          header: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              e.name,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          theme: ExpandableThemeData(
                                              bodyAlignment:
                                                  ExpandablePanelBodyAlignment
                                                      .center,
                                              headerAlignment:
                                                  ExpandablePanelHeaderAlignment
                                                      .center),
                                          collapsed: SizedBox(),
                                          expanded: Wrap(
                                            alignment: WrapAlignment.start,
                                            runAlignment: WrapAlignment.center,
                                            children: e.children?.map((item) {
                                                  return Container(
                                                    width: isDesktop ? 100 : 70,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                    child: InkWell(
                                                      onTap: () {
                                                        layersManageController
                                                            .changeLayer(item);
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: item.icon,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: layersManageController.baseMapLayer ==
                                                                            item
                                                                        ? Colors
                                                                            .blueAccent
                                                                        : Colors
                                                                            .transparent,
                                                                    width: 2)),
                                                          ),
                                                          Text(
                                                            item.name,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: item
                                                                        .isShow
                                                                    ? Colors
                                                                        .blueAccent
                                                                    : null),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList() ??
                                                [],
                                          ));
                                    }).toList()),
                              ),
                            ));
                      }),
                    );
                  });
            },
            iconWidget: Icon(
              Icons.layers_outlined,
              color: Colors.black,
            ),
            text: Text(
              XDLocalizations.of(context).layers,
            ),
          ),
        ));
  }
}

// class XDMapLayerChangeActionLayer extends XDMapActionLayer{
//   final XDMapLayersManageController layersManageController;
//   XDMapLayerChangeActionLayer({required this.layersManageController}):super(iconWidget: Icon(Icons.layers),text: Text("layer"));
//
// }
