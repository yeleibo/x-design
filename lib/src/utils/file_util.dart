import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../xd_design.dart';
import '../widgets/file/files_viewer.dart';

class XDFileUtil {
  static Future<String?> uploadFile(
      {required Uint8List fileBytes,
      required String fileName,
      String? uploadUrl}) async {
    if (uploadUrl != null) {
      assert(uploadUrl.startsWith("http"), "上传的url需要以http开头");
    }

    ///通过FormData
    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName)
    });
    RequestOptions requestOptions = RequestOptions(
        path: uploadUrl ??
            join(GetIt.instance.get<Dio>().options.baseUrl, 'api/files'),
        data: formData,
        method: 'POST',
        sendTimeout: const Duration(minutes: 5),
        contentType: "multipart/form-data");

    var dio = GetIt.instance.get<Dio>();

    var result = await dio.fetch<String>(requestOptions);

    return result.data;
  }

  static Future<String?> rename(
      {required Uint8List fileBytes,
        required String fileName,
        String? uploadUrl}) async {
    if (uploadUrl != null) {
      assert(uploadUrl.startsWith("http"), "上传的url需要以http开头");
    }

    ///通过FormData
    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName)
    });
    RequestOptions requestOptions = RequestOptions(
        path: uploadUrl ??
            join(GetIt.instance.get<Dio>().options.baseUrl, 'api/files/rename'),
        data: formData,
        method: 'POST',
        sendTimeout: const Duration(minutes: 5),
        contentType: "multipart/form-data");

    var dio = GetIt.instance.get<Dio>();

    var result = await dio.fetch<String>(requestOptions);

    return result.data;
  }

  static Future<String?> downloadFile(
      {required Uri fileUri, String? fileName}) async {
    try {
      if (isMobile) {
        launchUrl(fileUri, mode: LaunchMode.externalApplication);
      } else {
        if (kIsWeb) {
          // await WebImageDownloader.downloadImageFromWeb("https://picsum.photos/200");

          final http.Response response = await http.get(fileUri, headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
          });

          var url =
              html.Url.createObjectUrlFromBlob(html.Blob([response.bodyBytes]));
          html.AnchorElement(href: url)
            ..setAttribute('download', fileName ?? fileUri.path.getFileName())
            ..click();
        } else {
          // 让用户选择文件保存路径
          var savePath = await FilePicker.platform.saveFile(fileName: fileName);
          if (savePath != null) {
            await Dio().downloadUri(fileUri, savePath,
                options: Options(headers: {
                  "Access-Control-Allow-Origin":
                      "*", // Required for CORS support to work
                }));
            return savePath;
          }
        }
      }
    } catch (error) {
      throw Exception('下载失败：$error');
    }
    return null;
  }

  ///下载到临时文件夹中
  /// final fileDirectory =   Uri.directory('/home/myself/data/image', windows: false);
  /// final uri = Uri.parse(   'https://dart.dev/guides/libraries/library-tour#utility-classes');
  /// 安卓中的下载位置在/data/data/packageName/cache
  static Future<String> downloadFileToTemporary(
      {required Uri fileUri, String? fileName}) async {
    var temporaryDirectory = await getTemporaryDirectory();
    var savePath =
        join(temporaryDirectory.path, fileName ?? fileUri.path.getFileName());

    await Dio().downloadUri(fileUri, savePath,
        options: Options(headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
        }));
    return savePath;
  }

  ///打开文件
  ///final uri = Uri.parse(   'https://dart.dev/guides/libraries/library-tour#utility-classes');
  static Future openFile({required Uri fileUri}) async {
    if (isMobile) {
      var fileTempPath =
          await XDFileUtil.downloadFileToTemporary(fileUri: fileUri);

      OpenFile.open(fileTempPath,type: fileTempPath.contains(".dwg")?"application/x-autocad":null);
    } else {
      launchUrl(fileUri, mode: LaunchMode.externalApplication);
    }
  }

  ///文件预览
  static void viewFile(
      {BuildContext? context,
      required String fileType,
      String? filePath,
      Uint8List? fileBytes,
      String? fileName}) {
    assert(filePath != null || fileBytes != null);
    if (filePath != null && filePath.startsWith('[')) {
      try {
        var list = jsonDecode(filePath) as List;
        if (list.isNotEmpty) {
          filePath = list[0]['url'];
        }
      } catch (_) {}
    }

    if (fileType.toLowerCase() == "png" ||
        fileType.toLowerCase() == "jpg" ||
        fileType.toLowerCase() == "jpeg") {
      XDImageUtil.viewImage(
        context: context,
        imagePath: filePath,
        imageBytes: fileBytes,
        imageName: fileName,
      );
    } else {
      if (filePath != null) XDFileUtil.openFile(fileUri: Uri.parse(filePath));
    }
  }
  
  static void viewFiles<T>(BuildContext context,List<T> files,int initIndex,[ Future<String> Function(T fileKey)? getFileUrl]){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => FilesViewer<T>(
            files: files,
            initIndex: initIndex,
            getFileUrl: getFileUrl,
      ),
      ));
  }

  ///选择文件,其中PlatformFile的bytes是不为空的
  static Future<List<PlatformFile>?> pickFiles({
    bool multiple = true,
    bool pickFromCamera=true,
    FileType fileType = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    ///图片处理
    Future<List<PlatformFile>> getImages() async {
      final List<PlatformFile> files = [];

      RequestType pickAssetsFileType = fileType == FileType.audio
          ? RequestType.audio
          : fileType == FileType.image
              ? RequestType.image
              : RequestType.all;

      var assets = await AssetPicker.pickAssets(
        xdContext,
        pickerConfig: AssetPickerConfig(
          maxAssets: multiple ? 50 : 1,
          requestType: pickAssetsFileType,
          specialItemPosition:pickFromCamera? SpecialItemPosition.prepend:SpecialItemPosition.none,
          specialItemBuilder:pickFromCamera ?(context, path, length) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final result = await CameraPicker.pickFromCamera(
                context,
                pickerConfig:  CameraPickerConfig(
                  enableRecording:fileType== FileType.video,
                  resolutionPreset: ResolutionPreset.high,
                  maximumRecordingDuration: Duration(minutes: 2),
                ),
              );
              if (result != null) {
                final picker = context.findAncestorWidgetOfExactType<
                    AssetPicker<AssetEntity, AssetPathEntity>>()!;
                final builder =
                    picker.builder as DefaultAssetPickerBuilderDelegate;
                final p = builder.provider;
                await p.switchPath(PathWrapper<AssetPathEntity>(
                  path: await p.currentPath!.path.obtainForNewProperties(),
                ));
                p.selectAsset(result);
              }
            },
            child: const Center(child: Icon(Icons.camera_enhance, size: 42.0)),
          ):null,
        ),
      );

      if (assets != null) {
        for (final asset in assets) {
          final file = await asset.file;
          if (file != null) {
            final bytes = await file.readAsBytes();
            files.add(PlatformFile(
              name: file.path.split('/').last,
              path: file.path,
              size: bytes.length,
              bytes: bytes,
            ));
          }
        }
      }
      return files;
    }

    ///文件处理
    Future<List<PlatformFile>?>? getFiles() async {
      return await FilePicker.platform
          .pickFiles(
              type: FileType.any,
              withData: true,
              allowedExtensions: allowedExtensions,
              allowMultiple: multiple)
          .then((value) => value?.files);
    }

    if (isMobile) {
      if (fileType == FileType.any) {
        return await getFiles();
      } else if (fileType == FileType.image || fileType == FileType.video) {
        return await getImages();
      } else {
        List<PlatformFile>? files = await showDialog(
            context: xdContext,
            useRootNavigator: false,
            builder: (content) {
              return XDDialog(
                  title: const Text('附件格式:'),
                  fullScreen: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: const Column(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  child: Icon(Icons.image),
                                ),
                              ),
                              Text('图片'),
                            ],
                          ),
                          onTap: () async {
                            Navigator.of(xdContext)
                                .pop(await getImages());
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          child: const Column(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  child: Icon(Icons.folder),
                                ),
                              ),
                              Text('文件'),
                            ],
                          ),
                          onTap: () async {
                            Navigator.of(xdContext).pop(await getFiles());
                          },
                        ),
                      ],
                    ),
                  ));
            });
        return files;
      }
    } else {
      return await getFiles();
    }
  }

  ///选择单文件,其中PlatformFile的bytes是不为空的
  static Future<PlatformFile?> pickFile(
      {required BuildContext context,
      FileType fileType = FileType.any,
      List<String>? allowedExtensions}) async {
    return pickFiles(fileType: fileType, multiple: false)
        .then((files) => files?.firstOrNull);
  }
}
