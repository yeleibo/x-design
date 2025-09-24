import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:x_design/src/widgets/button/index.dart';
import 'package:x_design/src/widgets/map/search/map_search_controller.dart';
import 'package:x_design/src/widgets/message/message.dart';
import 'package:x_design/src/services/data_cache_service.dart';
import 'package:x_design/src/core/global.dart';

import '../../../../l10n/intl/xd_localizations.dart';

///地图搜索bar组件
class XDMapSearchBarLayer extends StatefulWidget {
  final XDMapSearchController mapSearchController;

  const XDMapSearchBarLayer({Key? key, required this.mapSearchController})
      : super(key: key);
  @override
  XDMapSearchBarLayerState createState() => XDMapSearchBarLayerState();
}

class XDMapSearchBarLayerState extends State<XDMapSearchBarLayer> {

  var textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late Set<String> historyKeywords;
  @override
  void initState() {
    focusNode.addListener(_onFocusChanged);
    var jsonStr=dataCacheService.getDataByDataName<String>("mapSearchKeywords");
    historyKeywords =jsonStr!=null?(jsonDecode(jsonStr) as List).map((e) => e as String).toSet(): {};
    super.initState();
  }

  void _onFocusChanged() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    widget.mapSearchController.clearSearchResult();
                  },
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: Color(0xff313234),
                  )),
              Expanded(
                  child: TextField(
                onSubmitted: (value) {
                  _toSearch();
                },
                controller: textController,
                textInputAction: TextInputAction.search,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  isCollapsed: true,
                  hintText: XDLocalizations.of(context).keyword,
                ),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              )),
              //清除内容按钮
              textController.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        textController.text = '';
                        if (!focusNode.hasFocus) {
                          FocusScope.of(context).requestFocus(focusNode);
                        }
                        widget.mapSearchController.clearSearchResult();
                      },
                      child: const CircleAvatar(
                        child: Icon(
                          Icons.close_outlined,
                          size: 12,
                          color: Colors.white,
                        ),
                        radius: 8,
                        backgroundColor: Colors.grey,
                      ))
                  : const SizedBox(),
              //搜索按钮
              XDButton(
                  type: ButtonType.text,
                  size: ButtonSize.small,
                  onClick: () {
                    _toSearch();
                  },
                  child: Text(XDLocalizations.of(context).search,
                      style: TextStyle(fontSize: 15)))
            ],
          ),
          if (focusNode.hasFocus && isMobile)
            Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: historyKeywords
                    .map((e) => _HistorySearchItemWidget(
                        str: e,
                        historyItemClickCallBack: (str) {
                          textController.text = str;
                          _toSearch();
                        }))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }

  void _toSearch() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (textController.text.isNotEmpty) {
      widget.mapSearchController.searchByKeyword(textController.text);
      historyKeywords={textController.text,...historyKeywords};
      //历史记录中只能存在5个
      if (historyKeywords.length > 5) {
        historyKeywords.remove(historyKeywords.last);
      }
      dataCacheService.saveData("mapSearchKeywords", jsonEncode(historyKeywords.toList()));
    } else {
      message.info(
          content: XDLocalizations.of(context).pleaseEnterTheQueryKeywordFirst,
          context: context);
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }
}

class _HistorySearchItemWidget extends StatelessWidget {
  final String str;
  final Function(String str)? historyItemClickCallBack;
  const _HistorySearchItemWidget(
      {Key? key, required this.str, this.historyItemClickCallBack})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: InkWell(
        onTap: () {
          if (historyItemClickCallBack != null) historyItemClickCallBack!(str);
        },
        child: Chip(
          label: Text(
            str,
            style: TextStyle(fontSize: 15),
          ),
          labelPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
      ),
    );
  }
}
