import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:x_design/xd_design.dart';

typedef XDDataPaginationResult<T, Q> = Future<XDPaginationResult<T>> Function(
    Q queryParam);

///分页查询的基类
class XDPaginationQueryParam {
  ///第多少页
  int pageIndex;

  get current => pageIndex + 1;

  ///每页大小
  @JsonKey(name: 'pageSize')
  int pageSize;

  ///是否倒序，true是倒序，false是正序，默认是true
  bool desc;

  @mustCallSuper
  void reset() {
    pageIndex = 1;
    pageSize = 10;
  }

  XDPaginationQueryParam({
    this.pageIndex = 0,
    this.pageSize = 10,
    this.desc = true,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'desc': desc,
      };
}

///选择模式
enum XDSelectMode {
  ///无选择
  none,

  ///单选
  singleSelect,

  ///多选
  multipleSelect,
}

enum XDFetchDataStatus {
  //获取数据中
  fetchingData,
  //获取数据失败
  fetchDataError,
  //获取数据成功
  fetchDataSuccess,
  //全部数据已获取
  fetchDataOver;
}

class XDListPageState<T, Q> {
  Q queryParam;
  XDPaginationResult<T>? data;
  List<T> selected = [];
  XDFetchDataStatus? status;

  XDListPageState({
    required this.queryParam,
    this.status,
    this.data,
    List<T>? selected,
  }) : selected = selected ?? [];

  XDListPageState<T, Q> copyWith({
    XDFetchDataStatus? status,
    XDPaginationResult<T>? data,
    List<T>? selected,
    Q? queryParam,
  }) {
    return XDListPageState(
      status: status ?? this.status,
      queryParam: queryParam ?? this.queryParam,
      data: data ?? this.data,
      selected: selected ?? this.selected,
    );
  }
}

class XDListPageController<T, Q extends XDPaginationQueryParam>
    extends ChangeNotifier {
  final XDDataPaginationResult<T, Q> fetchData;
  final XDSelectMode selectMode;
  late XDListPageState<T, Q> _state;

  XDListPageController({
    required Q initQueryParam,
    required this.fetchData,
    this.selectMode = XDSelectMode.none,
  }) {
    _state = XDListPageState(queryParam: initQueryParam);
  }

  XDListPageState<T, Q> get state => _state;

  void _updateState(XDListPageState<T, Q> newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      _updateState(_state.copyWith(status: XDFetchDataStatus.fetchingData));
      _state.queryParam.pageIndex = 0;
      var data = await fetchData(_state.queryParam);
      _updateState(_state.copyWith(
        status: XDFetchDataStatus.fetchDataSuccess,
        data: data,
      ));
    } catch (ex) {
      _updateState(_state.copyWith(status: XDFetchDataStatus.fetchDataError));
      rethrow;
    }
  }

  Future<void> fetchDataAsync() async {
    try {
      _updateState(_state.copyWith(status: XDFetchDataStatus.fetchingData));
      var data = await fetchData(_state.queryParam);
      if (isDesktop) {
        _updateState(_state.copyWith(
          status: XDFetchDataStatus.fetchDataSuccess,
          data: data,
        ));
      } else {
        _updateState(_state.copyWith(
          status: XDFetchDataStatus.fetchDataSuccess,
          data: (_state.data?.data == null
              ? data
              : data.copyWith(
                  data: List.of(_state.data!.data)..addAll(data.data))),
        ));
      }
    } catch (ex) {
      _updateState(_state.copyWith(status: XDFetchDataStatus.fetchDataError));
    }
  }

  void resetQueryParam() {
    _state.queryParam.reset();
    _updateState(_state.copyWith());
    fetchDataAsync();
  }

  void changePagination(int currentPageIndex, int pageSize) {
    _state.queryParam.pageIndex = currentPageIndex - 1;
    _state.queryParam.pageSize = pageSize;
    fetchDataAsync();
  }

  Future<void> search() async {
    try {
      _updateState(_state.copyWith(status: XDFetchDataStatus.fetchingData));
      _state.queryParam.pageIndex = 0;
      var data = await fetchData(_state.queryParam);
      _updateState(_state.copyWith(
        status: XDFetchDataStatus.fetchDataSuccess,
        data: data,
      ));
    } catch (ex) {
      _updateState(_state.copyWith(status: XDFetchDataStatus.fetchDataError));
      rethrow;
    }
  }

  void changeSelected(T item) {
    if (selectMode == XDSelectMode.none) return;
    
    if (_state.selected.contains(item)) {
      _state.selected.remove(item);
    } else {
      if (selectMode == XDSelectMode.singleSelect) {
        _state.selected.clear();
      }
      _state.selected.add(item);
    }
    _updateState(_state.copyWith());
  }

  void clearSelected() {
    _state.selected.clear();
    _updateState(_state.copyWith());
  }

  void changeSelectedList(List<T> items) {
    _state.selected.addAll(items);
    _updateState(_state.copyWith());
  }

  void fetchNextPage() {
    if (_state.status == XDFetchDataStatus.fetchingData) {
      return;
    }
    if (_state.data?.totalCount != null &&
        _state.data?.totalCount == _state.data?.data.length) {
      _state.status = XDFetchDataStatus.fetchDataOver;
      _updateState(_state.copyWith(status: _state.status));
    } else {
      _state.queryParam.pageIndex =
          ((_state.data?.data.length ?? 0) ~/ _state.queryParam.pageSize);
      _updateState(_state.copyWith(queryParam: _state.queryParam));
      fetchDataAsync();
    }
  }
}
