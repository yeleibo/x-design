import 'package:flutter/material.dart';
import 'package:x_design/xd_design.dart';

class XDPaginationList<T, Q extends XDPaginationQueryParam> extends StatefulWidget {
  final Widget Function(BuildContext context, T item) itemBuilder;
  final XDDataPaginationResult<T, Q> fetchData;
  final Q initQueryParam;
  final XDSelectMode selectMode;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const XDPaginationList({
    super.key,
    required this.itemBuilder,
    required this.fetchData,
    required this.initQueryParam,
    this.selectMode = XDSelectMode.none,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  State<XDPaginationList<T, Q>> createState() => _XDPaginationListState<T, Q>();
}

class _XDPaginationListState<T, Q extends XDPaginationQueryParam>
    extends State<XDPaginationList<T, Q>> {
  late XDListPageController<T, Q> _controller;

  @override
  void initState() {
    super.initState();
    _controller = XDListPageController<T, Q>(
      initQueryParam: widget.initQueryParam,
      fetchData: widget.fetchData,
      selectMode: widget.selectMode,
    );
    _controller.addListener(_onStateChanged);
    // 初始加载数据
    _controller.fetchDataAsync();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    if (state.status == XDFetchDataStatus.fetchingData && 
        (state.data == null || state.data!.data.isEmpty)) {
      return widget.loadingWidget ?? 
        const Center(child: CircularProgressIndicator());
    }

    if (state.status == XDFetchDataStatus.fetchDataError && 
        (state.data == null || state.data!.data.isEmpty)) {
      return widget.errorWidget ?? 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('加载失败'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _controller.refresh(),
                child: const Text('重试'),
              ),
            ],
          ),
        );
    }

    if (state.data?.data.isEmpty == true) {
      return widget.emptyWidget ?? 
        const Center(child: Text('暂无数据'));
    }

    return RefreshIndicator(
      onRefresh: () => _controller.refresh(),
      child: ListView.builder(
        itemCount: state.data?.data.length ?? 0,
        itemBuilder: (context, index) {
          final item = state.data!.data[index];
          return widget.itemBuilder(context, item);
        },
      ),
    );
  }

  // Expose controller methods for external use
  XDListPageController<T, Q> get controller => _controller;
}