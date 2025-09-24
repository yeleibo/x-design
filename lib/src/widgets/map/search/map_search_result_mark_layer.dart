import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../image/image_widget.dart';
import 'map_search_controller.dart';

class XDMapSearchResultMarkLayer extends StatelessWidget {
  final XDMapSearchController searchController;
  const XDMapSearchResultMarkLayer(
      {super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: searchController,
      child: Selector<XDMapSearchController, MapSearchResult?>(
        builder: (context, currentResult, child) {
          if (currentResult?.type == "point" ||
              currentResult?.type == 'address') {
            //点位置
            return MarkerLayer(markers: [
              //我的位置
              Marker(
                point: currentResult!.points.first,
                width: 80,
                height: 80,
                child: Align(
                    alignment: const FractionalOffset(0.5, 0),
                    child: XDImageWidget(
                      imagePath: 'assets/images/map/position.png',
                      package: "x_design",
                      width: 40,
                      height: 40,
                    )),
              ),
            ]);
          } else if (currentResult?.type == "polygon") {
            //线位置

            return PolylineLayer(
              polylines: _getPolylines(currentResult!),
            );
          }
          return const SizedBox();
        },
        selector: (context, controller) =>
            controller.searchResultSelectedIndex == null
                ? null
                : controller
                    .searchResult[controller.searchResultSelectedIndex!],
      ),
    );
  }

  List<Polyline> _getPolylines(MapSearchResult searchResult) {
    var searchResultPolylines = <Polyline>[];

    if (searchResult.pointsAll != null) {
      //pointsAll光缆段时会有光缆所属的全部光缆
      searchResultPolylines.add(Polyline(
        color: const Color.fromARGB(255, 0, 255, 255),
        strokeWidth: 5,

        points: searchResult
            .pointsAll!, // An optional tag to distinguish polylines in `onTap` callback
      ));
    }
    //当前端
    searchResultPolylines.add(Polyline(
      color: const Color.fromARGB(255, 170, 102, 205),
      strokeWidth: 5,
      points: searchResult
          .points, // An optional tag to distinguish polylines in `onTap` callback
    ));

    return searchResultPolylines;
  }
}


