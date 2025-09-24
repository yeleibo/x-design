import 'dart:typed_data';

import 'package:http/http.dart' as http;
extension StringExtension on String {
  ///根据文件url地址获取文件数据
  Future<Uint8List> getFileBytes({Map<String, String>? otherHeaders,String? token}) async {

    var headers= {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    };
    if(otherHeaders!=null){
      headers.addAll(otherHeaders);
    }
    if(token!=null){
      headers["Authorization"]="Bearer $token";
    }
      return await http.get(Uri.parse(this), headers: headers).then((response) => response.bodyBytes);
  }

  ///获取文件类型
  String getFileType(){
    return getFileExtension();
  }
  ///获取文件名称
  String getFileName(){
    return split('/').last;
  }
  ///获取文件的后缀
  String getFileExtension(){
    return this.split('?').first.split('.').last.toLowerCase();
  }
  ///判断是否是视频
  bool isVideoFile() {
    final extension = getFileExtension();
    return [
      'mp4', 'mov', 'avi', 'wmv', 'flv', 'mkv', 'webm', '3gp', 'mpeg', 'mpg'
    ].contains(extension);
  }
  ///判断是否是图片
  bool isImageFile() {
    final extension = getFileExtension();
    return [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'tiff', 'svg'
    ].contains(extension);
  }
  ///判断是否是图片
  bool isNetworkUrl() {
    return startsWith("http://") || startsWith("https://");
  }
}