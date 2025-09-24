part of 'list_page_bloc.dart';

 class XDListPageState<T,Q> {
   Q queryParam;

   XDPaginationResult<T>? data;

   List<T> selected=[];

   XDFetchDataStatus? status;
   XDListPageState({required this.queryParam,this.status,this.data, List<T>? selected}):selected=selected??[];

   XDListPageState<T,Q> copyWith({XDFetchDataStatus? status,XDPaginationResult<T>? data,List<T>? selected,Q? queryParam}){
     return XDListPageState(status: status,queryParam: queryParam??this.queryParam,data: data??this.data,selected: selected??this.selected);
   }
 }

