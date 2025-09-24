part of 'list_page_bloc.dart';

@immutable
abstract class XDListPageEvent<T> {}

///刷新事件
class XDRefreshEvent  extends XDListPageEvent {}
///获取事件
class XDFetchDataEvent  extends XDListPageEvent {}

///获取事件
class XDFetchNextPageEvent  extends XDListPageEvent {}
///重置查询参数事件
class XDResetQueryParamEvent  extends XDListPageEvent {}

///改变分页信息
///改变分页信息
class XDChangePagination extends XDListPageEvent {
  final int currentPageIndex;
  final int pageSize;
  XDChangePagination(this.currentPageIndex, this.pageSize);
}
///点击查询事件
class XDSearchListEvent  extends XDListPageEvent {}
///添加选中事件
class XDSelectedChange<T>  extends XDListPageEvent {
  final T changeSelectedItem;
  XDSelectedChange(this.changeSelectedItem);
}
///选中多个
class XDSelectedListChange<T>  extends XDListPageEvent {
  final List<T> changeSelectedItems;
  XDSelectedListChange(this.changeSelectedItems);
}
///清除选中
class XDClearSelectedEvent  extends XDListPageEvent {}