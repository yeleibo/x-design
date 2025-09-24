import 'package:x_design/src/widgets/pagination/pagination_result.dart';


class XDTablePaginationConfig{
   int total;
   int current;
   int pageSize;
  XDTablePaginationConfig({this.total=0,this.current=1,this.pageSize = 10});

  factory XDTablePaginationConfig.withPaginationResult(XDPaginationResult? paginationResult){
    return XDTablePaginationConfig(
        total: paginationResult?.totalCount ?? 0,
        current: (paginationResult?.pageIndex ?? 0) + 1,
       pageSize: paginationResult?.pageSize??10
    );
  }

  XDTablePaginationConfig copyWith({int? current,int? pageSize}){
    return XDTablePaginationConfig(total: total,current: current??this.current,pageSize: pageSize??this.pageSize);
  }
}