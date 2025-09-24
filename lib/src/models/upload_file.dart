
import 'dart:typed_data';
class UploadFile{
 dynamic id;
  ///文件名称
 String? name;
 /// 文件上传成功后的下载/访问地址
 String url;

 String? type;

 Uint8List? fileBytes;

 UploadFile({this.name,required this.url,this.id,this.type,this.fileBytes});

 Map<String, dynamic> toJson() {
   return {"name":name,"url":url,"type":type};
 }
 factory UploadFile.fromJson(Map<String, dynamic> json) {
   return UploadFile(
     name: json['name'],
     url: json['url'],
     type: json['type'],
   );
 }
}