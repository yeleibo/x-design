import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import 'map_search_controller.dart';

typedef MapSearchResultBuilder = Widget Function(
    BuildContext context, MapSearchResult item)?;

///通过card的方式展示结果
class XDSearchResultShowWithCard extends StatefulWidget {
  final XDMapSearchController searchController;
  final EdgeInsets? margin;
  final MapSearchResultBuilder itemBuilder;
  const XDSearchResultShowWithCard(
      {super.key,
      this.itemBuilder,
      required this.searchController,
      this.margin});

  @override
  State<XDSearchResultShowWithCard> createState() =>
      _XDSearchResultShowWithCardState();
}

class _XDSearchResultShowWithCardState extends State<XDSearchResultShowWithCard> {
  late ScrollController scrollController = ScrollController();
  var startTap = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: widget.margin,
          child: ChangeNotifierProvider.value(
              value: widget.searchController,
              child: Consumer<XDMapSearchController>(
                  builder: (_, searchController, child) {
                return Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (PointerDownEvent p) {
                    startTap = p.position.dx;
                  },
                  onPointerUp: (value) {
                    if (searchController.searchResultSelectedIndex == null)
                      return;
                    if ((value.position.dx - startTap).abs() > 50) {
                      if (value.position.dx - startTap < 0) {
                        if (searchController.searchResultSelectedIndex! <
                            searchController.searchResult.length - 1) {
                          searchController.changeSelectedResult(searchController
                                  .searchResult[
                              searchController.searchResultSelectedIndex! + 1]);
                        }
                      } else {
                        if (searchController.searchResultSelectedIndex! > 0) {
                          searchController.changeSelectedResult(searchController
                                  .searchResult[
                              searchController.searchResultSelectedIndex! - 1]);
                        }
                      }
                    }

                    scrollController.animateTo(
                        searchController.searchResultSelectedIndex! *
                            (screenSize.width * (0.86 + 0.01 * 2)),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: searchController.searchResult.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var item = searchController.searchResult[index];

                          return GestureDetector(
                            onTap: () {
                              searchController.changeSelectedResult(item);
                            },
                            child: Container(
                              width: screenSize.width * 0.86,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0),
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0),
                                  ]),
                              margin: EdgeInsets.fromLTRB(
                                  index == 0
                                      ? screenSize.width * 0.07
                                      : screenSize.width * 0.01,
                                  0,
                                  index ==
                                          searchController.searchResult.length -
                                              1
                                      ? screenSize.width * 0.1
                                      : screenSize.width * 0.01,
                                  20),
                              alignment: Alignment.topCenter,
                              child: widget.itemBuilder != null
                                  ? widget.itemBuilder!(context, item)
                                  : XDSearchResultItemShowWithCommon(
                                      item: item,
                                    ),
                            ),
                          );
                        }),
                  ),
                );
              })),
        ));
  }
}

///公用的展示
class XDSearchResultItemShowWithCommon extends StatelessWidget {
  final MapSearchResult item;
  const XDSearchResultItemShowWithCommon({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var itemAttributes = item.attributes.keys
        .where((key) =>
            item.attributes[key] != null && item.attributes[key]!.isNotEmpty)
        .map((key) => Container(
              padding: EdgeInsets.only(
                bottom: 5,
              ),
              child: Text(
                '$key:${item.attributes[key]}',
                style: TextStyle(fontSize: 14),
              ),
              alignment: Alignment.centerLeft,
            ))
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //结果属性
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: itemAttributes,
          ),
        )),
        //结果操作
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  var mapController = MapController.of(context);
                  mapController.move(
                      item.points.first, mapController.camera.zoom);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "PositionOnMap",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                  ),
                ),
              )),
            ],
          ),
        )
      ],
    );
  }
}

///通过List的方式展示结果
class XDSearchResultShowWithList extends StatelessWidget {
  final XDMapSearchController searchController;
  final MapSearchResultBuilder itemBuilder;
  const XDSearchResultShowWithList(
      {super.key, required this.searchController, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: searchController,
        child: Consumer<XDMapSearchController>(
            builder: (_, searchController, child) {
          return ListView.builder(
              itemBuilder: (_, index) {
                var item = searchController.searchResult[index];
                return itemBuilder != null
                    ? itemBuilder!(context, item)
                    : XDSearchResultItemShowWithCommon(
                        item: item,
                      );
              },
              itemCount: searchController.searchResult.length);
        }));
  }
}
