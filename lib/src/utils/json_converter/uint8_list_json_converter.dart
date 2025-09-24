import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';


///Uint8List?的json转换器
class Uint8ListNullableJsonConverter  extends JsonConverter<Uint8List?, String?> {
  const Uint8ListNullableJsonConverter();
  @override
  Uint8List? fromJson(String? json) {
    if(json==null || json.isEmpty) return null;
    // 将byte[]转换为Base64字符串
    return   base64Decode(json);
  }

  @override
  String? toJson(Uint8List? object) {
    if(object==null) return null;
    return base64Encode(object);
  }

}
///Uint8List的json转换器
class Uint8ListJsonConverter  extends JsonConverter<Uint8List, String> {
  const Uint8ListJsonConverter();
  @override
  Uint8List fromJson(String json) {

    // 将byte[]转换为Base64字符串
    return   base64Decode(json);
  }

  @override
  String toJson(Uint8List object) {
      return base64Encode(object);
  }

}
