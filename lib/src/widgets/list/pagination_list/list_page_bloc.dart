import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:x_design/xd_design.dart';





part 'list_page_event.dart';
part 'list_page_state.dart';

typedef XDDataPaginationResult<T, Q> = Future<XDPaginationResult<T>> Function(
    Q queryParam);

class XDListPageBloc<T, Q extends XDPaginationQueryParam>
    extends Bloc<XDListPageEvent, XDListPageState<T, Q>> {
  final XDDataPaginationResult<T, Q> fetchData;
  final XDSelectMode selectMode;
  XDListPageBloc(
      {required Q initQueryParam,
      required this.fetchData,
      this.selectMode = XDSelectMode.none})
      : super(XDListPageState(queryParam: initQueryParam)) {
    on<XDRefreshEvent>(_onRefreshEvent);
    on<XDFetchDataEvent>(_onFetchDataEvent);
    on<XDResetQueryParamEvent>(_onResetQueryParamEvent);
    on<XDChangePagination>(_onChangePagination);
    on<XDSearchListEvent>(_onSearchEvent);
    on<XDSelectedChange<T>>(_onChangeSelected);
    on<XDClearSelectedEvent>(_onClearSelectedEvent);
    on<XDSelectedListChange<T>>(_onSelectedListChange);
    on<XDFetchNextPageEvent>(_onFetchNextPageEvent);
  }

  Future<void> _onFetchDataEvent(
      XDFetchDataEvent event, Emitter<XDListPageState<T, Q>> emit) async {
    try {
      emit(state.copyWith(status: XDFetchDataStatus.fetchingData));
      var data = await fetchData(state.queryParam);
      if (isDesktop) {

        emit(state.copyWith(
            status: XDFetchDataStatus.fetchDataSuccess, data: data));
      } else {
        emit(state.copyWith(
            status: XDFetchDataStatus.fetchDataSuccess,
            data: (state.data?.data == null
                ? data
                : data.copyWith(
                data: List.of(state.data!.data)..addAll(data.data)))));
      }

    } catch (ex) {
      emit(state.copyWith(status: XDFetchDataStatus.fetchDataError));
      // rethrow;
    }
  }

  FutureOr<void> _onResetQueryParamEvent(
      XDResetQueryParamEvent event, Emitter<XDListPageState<T, Q>> emit) {
    state.queryParam.reset();
    emit(state.copyWith());
    add(XDFetchDataEvent());
  }

  FutureOr<void> _onChangePagination(
      XDChangePagination event, Emitter<XDListPageState<T, Q>> emit) {
    state.queryParam.pageIndex = event.currentPageIndex - 1;
    state.queryParam.pageSize = event.pageSize;
    add(XDFetchDataEvent());
  }

  Future<FutureOr<void>> _onSearchEvent(
      XDSearchListEvent event, Emitter<XDListPageState<T, Q>> emit) async {
    try {
      emit(state.copyWith(status: XDFetchDataStatus.fetchingData));
      state.queryParam.pageIndex=0;
      var data = await fetchData(state.queryParam);

      emit(state.copyWith(
          status: XDFetchDataStatus.fetchDataSuccess, data: data));

    } catch (ex) {
      emit(state.copyWith(status: XDFetchDataStatus.fetchDataError));
      rethrow;
    }
  }

  FutureOr<void> _onChangeSelected(
      XDSelectedChange<T> event, Emitter<XDListPageState<T, Q>> emit) {
    if (selectMode == XDSelectMode.none) return null;
    if (state.selected.contains(event.changeSelectedItem)) {
      state.selected.remove(event.changeSelectedItem);
    } else {
      if (selectMode == XDSelectMode.singleSelect) {
        state.selected.clear();
      }
      state.selected.add(event.changeSelectedItem);
    }
    emit(state.copyWith());
  }

  FutureOr<void> _onClearSelectedEvent(
      XDClearSelectedEvent event, Emitter<XDListPageState<T, Q>> emit) {
    state.selected.clear();
    emit(state.copyWith());
  }

  FutureOr<void> _onSelectedListChange(
      XDSelectedListChange<T> event, Emitter<XDListPageState<T, Q>> emit) {
    state.selected.addAll(event.changeSelectedItems);
    emit(state.copyWith());
  }

  FutureOr<void> _onFetchNextPageEvent(
      XDFetchNextPageEvent event, Emitter<XDListPageState<T, Q>> emit) {
    if (state.status == XDFetchDataStatus.fetchingData) {
      return null;
    }
    if (state.data?.totalCount != null &&
        state.data?.totalCount == state.data?.data.length) {
      state.status = XDFetchDataStatus.fetchDataOver;
      emit(state.copyWith(status: state.status));
    } else {
      state.queryParam.pageIndex =
      ((state.data?.data.length ?? 0) ~/ state.queryParam.pageSize);
      emit(state.copyWith(queryParam: state.queryParam));
      add(XDFetchDataEvent());
    }
  }

  Future<void> _onRefreshEvent(XDRefreshEvent event, Emitter<XDListPageState<T, Q>> emit) async {
    try {
      emit(state.copyWith(status: XDFetchDataStatus.fetchingData));
      state.queryParam.pageIndex=0;
      var data = await fetchData(state.queryParam);

      emit(state.copyWith(
          status: XDFetchDataStatus.fetchDataSuccess, data: data));

    } catch (ex) {
      emit(state.copyWith(status: XDFetchDataStatus.fetchDataError));
      rethrow;
    }
  }
}


///分页查询的基类
class XDPaginationQueryParam {
  ///第多少页
  int pageIndex;

  get current => pageIndex+1;
  ///每页大小
  @JsonKey(name: 'pageSize')
  int pageSize;
  ///是否倒序，true是倒序，false是正序，默认是true
  bool desc;
  @mustCallSuper
  void reset(){
    pageIndex=1;
    pageSize=10;
  }



  XDPaginationQueryParam(
      { this.pageIndex=0, this.pageSize = 10, this.desc = true, });

  Map<String, dynamic> toJson() =>  <String, dynamic>{
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

enum XDFetchDataStatus{
  //获取数据中
  fetchingData,
  //获取数据失败
  fetchDataError,
  //获取数据成功
  fetchDataSuccess,
  //全部数据已获取
  fetchDataOver;
}