import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:x_design/src/utils/extension/string_extension.dart';
import 'package:x_design/src/utils/file_util.dart';

import '../image/image_widget.dart';
import 'video_viewer.dart';
///多文件查看器
class FilesViewer<T> extends StatefulWidget {
  final List<T> files;
  final int initIndex;
  final Future<String> Function(T fileKey)? getFileUrl;
  const FilesViewer(
      {super.key, required this.files, this.initIndex = 0, this.getFileUrl});

  @override
  State<FilesViewer<T>> createState() => _FilesViewerState<T>();
}

class _FilesViewerState<T> extends State<FilesViewer<T>> {
  late PageController controller;
  int currentIndex = 0;
  List<String> fileUrls = [];
  List<Widget> children = [];
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget unknownFileWidget(String fileUrl)=> GestureDetector(onTap: (){
  XDFileUtil.openFile(fileUri: Uri.parse(fileUrl));
  },child: Center(
  child: Text("文件暂不支持预览,点击尝试打开"),
  ),);
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initIndex);
    currentIndex = widget.initIndex;
    controller.addListener(() {
      currentIndex = controller.page!.toInt();
      setState(() {});
    });
    children= widget.files.map((e){

      Widget child = unknownFileWidget(e.toString());
      if (e == null) {
        return child = Center(
          child: Text("文件获取中"),
        );
      } else {
        if (widget.getFileUrl != null) {
          child = FutureBuilder<String>(
              future: widget.getFileUrl!.call(e),
              builder: (_, sp) {
                if (sp.hasError) {
                  return Center(
                    child: Text("文件加载出错"),
                  );
                } else {
                  if (sp.hasData) {
                    return buildItem(sp.data!);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              });
        } else {
          child = buildItem(e.toString());
        }
      }
      return _KeepStatePage(child: child);
    }).toList();
  }

  Widget buildItem(String e) {
    Widget child = unknownFileWidget(e);
    if (e.isImageFile()) {
      child = XDImageWidget(imagePath: e);
    } else if (e.isVideoFile()) {
      child = VideoViewer( controller:  VideoPlayerController.networkUrl(Uri.parse(e)),);
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${currentIndex + 1}/${widget.files.length}"),
      ),
      body: PageView(
        controller: controller,
        children: children,
      ),
    );
  }
}

class _KeepStatePage extends StatefulWidget {
  final Widget child;
  const _KeepStatePage({super.key, required this.child});

  @override
  State<_KeepStatePage> createState() => _KeepStatePageState();
}

class _KeepStatePageState extends State<_KeepStatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

