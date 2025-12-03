import 'dart:async';

import 'package:easy_refresh/easy_paging.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../../l10n/intl/xd_localizations.dart';
import '../../../xd_design.dart';

class XDList<T, Q extends XDPaginationQueryParam> extends StatefulWidget {
  final Widget Function(BuildContext context, T item) itemBuilder;
  final XDDataPaginationResult<T, Q> fetchData;
  final EasyRefreshController? controller;
  final Q initQueryParam;
  const XDList({
    super.key,
    this.controller,
    required this.fetchData,
    required this.initQueryParam,
    required this.itemBuilder,
  });

  @override
  State<XDList<T, Q>> createState() => _XDListState<T, Q>();
}

class _XDListState<T, Q extends XDPaginationQueryParam>
    extends State<XDList<T, Q>> with AutomaticKeepAliveClientMixin {
  List<T>? data;
  late Q queryParam;
  int? total;

  /// Check if there is no data.
  bool get isEmpty => data != null && data!.isEmpty;

  /// EasyRefresh controller.
  late EasyRefreshController _refreshController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    queryParam = widget.initQueryParam;
    _refreshController = widget.controller ?? EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      refreshOnStart: true,
      header: ClassicHeader(
        armedText: XDLocalizations.of(context).releaseToRefresh,
        dragText: XDLocalizations.of(context).startRefreshing,
        readyText: XDLocalizations.of(context).refreshing,
        processingText: XDLocalizations.of(context).processing,
        processedText: XDLocalizations.of(context).refreshSuccessful,
        failedText: XDLocalizations.of(context).refreshFailed,
        showMessage: false,
      ),
      controller: _refreshController,
      footer: ClassicFooter(
        armedText: XDLocalizations.of(context).releaseToRefresh,
        dragText: XDLocalizations.of(context).startRefreshing,
        readyText: XDLocalizations.of(context).refreshing,
        processingText: XDLocalizations.of(context).processing,
        processedText: XDLocalizations.of(context).loadingCompleted,
        failedText: XDLocalizations.of(context).refreshFailed,
        noMoreText: XDLocalizations.of(context).noMore,
        showMessage: false,
      ),
      onRefresh: () async {
        queryParam.pageIndex = 0;
        // queryParam.current = 1;
        var nextPageData = await widget.fetchData(queryParam);
        data = nextPageData.data;
        total = nextPageData.total;
        setState(() {});
      },
      onLoad: () async {
        if (total != null && data!.length >= total!) {
          return IndicatorResult.noMore;
        }

        queryParam.pageIndex = ((data?.length ?? 0) ~/ queryParam.pageSize);
        // queryParam.current = ((data?.length ?? 0) ~/ queryParam.pageSize);
        var nextPageData = await widget.fetchData(queryParam);
        total = nextPageData.total;
        if (data == null) {
          data = nextPageData.data;
        } else {
          data!.addAll(nextPageData.data);
        }
        setState(() {});

        return IndicatorResult.success;
      },
      child: CustomScrollView(
        slivers: buildSlivers(),
      ),
    );
  }

  /// Build slivers.
  List<Widget> buildSlivers() {
    final header = EasyRefresh.defaultHeaderBuilder();
    final footer = EasyRefresh.defaultFooterBuilder();
    Widget? emptyWidget;
    if (isEmpty) {
      emptyWidget = Center(
        child: Text("暂无数据"),
      );
    }
    return [
      if (header.position == IndicatorPosition.locator)
        const HeaderLocator.sliver(),
      if (emptyWidget != null)
        SliverFillViewport(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return emptyWidget;
            },
            childCount: 1,
          ),
        ),
      buildSliver(),
      if (footer.position == IndicatorPosition.locator)
        const FooterLocator.sliver(),
    ];
  }

  /// Build sliver.
  Widget buildSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return widget.itemBuilder(context, data![index]);
        },
        childCount: data?.length ?? 0,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant XDList<T, Q> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initQueryParam != oldWidget.initQueryParam) {
      queryParam = widget.initQueryParam;
      setState(() {});
    }
    if (oldWidget.controller != widget.controller) {
      _refreshController = widget.controller ?? EasyRefreshController();
    }
  }
}
