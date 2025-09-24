
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

import '../../../xd_design.dart';

///web端不能上传大文件，如何想要web端实现，参考https://github.com/warjeh/flutter_web_upload
class XDFileUpload extends StatefulWidget {
  ///是否禁用
  final bool disabled;

  ///初始文件
  final List<UploadFile>? initialFiles;

  ///是否多选
  final bool multiple;

  ///上传的地址,eg:“http://www.baidu.com/upload”
  final String? uploadUrl;

  ///上次的文件类型 默认any 选择文件,image 选择图片,custom 自选
  final FileType fileType;

  ///允许上次的文件后缀
  final List<String>? allowedExtensions;
  final Function(List<UploadFile> files) onChange;

  const XDFileUpload(
      {super.key,
      this.uploadUrl,
      this.disabled = false,
      this.initialFiles,
      this.fileType = FileType.any,
      this.allowedExtensions,
      required this.onChange,
      this.multiple = false});

  @override
  State<XDFileUpload> createState() => _XDFileUploadState();
}

class _XDFileUploadState extends State<XDFileUpload> {
  List<UploadFile> files = [];
  @override
  void initState() {
    super.initState();
    if (widget.initialFiles != null) {
      files.addAll(widget.initialFiles!);
    }
  }

  @override
  Widget build(BuildContext context) {
    //todo:移动端如何是选择图片时这个地方的展示要换
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.disabled)
          XDButton(
              onClick: () async {
                var pickFiles = await XDFileUtil.pickFiles(
                    multiple: widget.multiple,
                    fileType: widget.fileType,
                    allowedExtensions: widget.allowedExtensions);
                if (pickFiles != null) {
                  for (var file in pickFiles) {
                    var fileName = file.name;
                    var filePath = await XDFileUtil.uploadFile(
                        fileBytes: file.bytes!,
                        fileName: fileName,
                        uploadUrl: widget.uploadUrl);
                    if (filePath != null) {
                      files.add(UploadFile(name: fileName, url: filePath));
                    }
                  }
                  widget.onChange(files);
                  setState(() {});
                }
                // if (widget.fileType == FileType.image) {
                //   var pickFiles = await XDFileUtil.pickFiles(
                //       multiple: widget.multiple,
                //       fileType: widget.fileType,
                //       allowedExtensions: widget.allowedExtensions);
                //   if (pickFiles != null) {
                //     for (var file in pickFiles) {
                //       var fileName = file.name;
                //       var filePath = await XDFileUtil.uploadFile(
                //           fileBytes: file.bytes!,
                //           fileName: fileName,
                //           uploadUrl: widget.uploadUrl);
                //       if (filePath != null) {
                //         files.add(UploadFile(name: fileName, url: filePath));
                //       }
                //     }
                //     widget.onChange(files);
                //     setState(() {});
                //   }
                // } else {
                //   showDialog(
                //       context: context,
                //       useRootNavigator: false,
                //       builder: (content) {
                //         return XDDialog(
                //           title: const Text('附件格式:') ,
                //             fullScreen: false,
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   InkWell(
                //                     child: const Column(
                //                       children: [
                //                         SizedBox(
                //                           width: 50,
                //                           height: 50,
                //                           child: CircleAvatar(
                //                             child: Icon(Icons.image),
                //                           ),
                //                         ),
                //                         Text('图片'),
                //                       ],
                //                     ),
                //                     onTap: () async {
                //                       var pickFiles =
                //                       await XDFileUtil.pickFiles(
                //                           multiple: widget.multiple,
                //                           fileType: FileType.image,
                //                           allowedExtensions:
                //                           widget.allowedExtensions);
                //                       if (pickFiles != null) {
                //                         for (var file in pickFiles) {
                //                           var fileName = file.name;
                //                           var filePath =
                //                           await XDFileUtil.uploadFile(
                //                               fileBytes: file.bytes!,
                //                               fileName: fileName,
                //                               uploadUrl:
                //                               widget.uploadUrl);
                //                           if (filePath != null) {
                //                             files.add(UploadFile(
                //                                 name: fileName,
                //                                 url: filePath));
                //                           }
                //                         }
                //                         widget.onChange(files);
                //                         Navigator.of(context).pop();
                //                         setState(() {});
                //                       }
                //                     },
                //                   ),
                //                   const SizedBox(width: 30,),
                //                   InkWell(
                //                     child: const Column(
                //                       children: [
                //                         SizedBox(
                //                           width: 50,
                //                           height: 50,
                //                           child: CircleAvatar(
                //                             child: Icon(Icons.folder),
                //                           ),
                //                         ),
                //                         Text('文件'),
                //                       ],
                //                     ),
                //                     onTap: () async {
                //                       var pickFiles =
                //                       await XDFileUtil.pickFiles(
                //                           multiple: widget.multiple,
                //                           fileType: FileType.any,
                //                           allowedExtensions:
                //                           widget.allowedExtensions);
                //                       if (pickFiles != null) {
                //                         for (var file in pickFiles) {
                //                           var fileName = file.name;
                //                           var filePath =
                //                           await XDFileUtil.uploadFile(
                //                               fileBytes: file.bytes!,
                //                               fileName: fileName,
                //                               uploadUrl:
                //                               widget.uploadUrl);
                //                           if (filePath != null) {
                //                             files.add(UploadFile(
                //                                 name: fileName,
                //                                 url: filePath));
                //                           }
                //                         }
                //
                //                         widget.onChange(files);
                //                         Navigator.of(context).pop();
                //                         setState(() {});
                //                       }
                //                     },
                //                   ),
                //                 ],
                //               ),
                //             ));
                //       });
                // }
              },
              type: ButtonType.normal,
              child: Text(XDLocalizations.of(context).upload)),
        ...files
            .map((e) => Row(
                  children: [
                    Expanded(
                      child:
                          Text(e.name ?? '', overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                        onPressed: () async {
                          var baseUrl =
                              GetIt.instance.get<Dio>().options.baseUrl;
                          XDFileUtil.viewFile(
                            filePath: baseUrl+e.url,
                            context: context,
                            fileType: e.url.getFileType(),
                            fileName: e.name,
                          );
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.blueAccent,
                        )),
                    if (isDesktop)
                      IconButton(
                          onPressed: () async {
                            var baseUrl =
                                GetIt.instance.get<Dio>().options.baseUrl;
                            await XDFileUtil.downloadFile(
                                fileUri: Uri.parse(join(baseUrl, e.url)),
                                fileName: e.name ?? '');
                          },
                          icon: Icon(
                            Icons.download_outlined,
                            color: Colors.blueAccent,
                          )),
                    if (!widget.disabled)
                      IconButton(
                          onPressed: () {
                            files.remove(e);
                            widget.onChange(files);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          )),
                  ],
                ))
            .toList()
      ],
    );
  }

  @override
  void didUpdateWidget(covariant XDFileUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFiles != widget.initialFiles) {
      if (widget.initialFiles != null) {
        files.clear();
        files.addAll(widget.initialFiles!);
        setState(() {});
      }
    }
  }
}
