import 'package:json_annotation/json_annotation.dart';



@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class XDPaginationResult<T> {
  final int pageIndex;
  final int? pageSize;
  final int totalCount;
  final List<T> data;

  const XDPaginationResult(
      {this.pageSize,
       this.pageIndex=0,
       this.totalCount=0,
       this.data=const []});


  ///解析json转换成对象
  factory XDPaginationResult.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginationResultFromJson(json, fromJsonT);



  ///copyWith
  XDPaginationResult<T> copyWith({
    int? pageIndex,
    int? pageSize,
    int? totalCount,
    List<T>? data,
  }) {
    return XDPaginationResult<T>(
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      data: data ?? this.data,
    );
  }
}

XDPaginationResult<T> _$PaginationResultFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    ) =>
    XDPaginationResult<T>(
      pageSize: json['pageSize'] as int?,
      pageIndex: json['pageIndex'] as int? ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
      data:
      (json['data'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
    );
