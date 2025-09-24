import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
///视频查看器
class VideoViewer extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoViewer({super.key,required this.controller});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  /// Whether the widget.controller is playing.
  /// 播放控制器是否在播放
  bool get isControllerPlaying => widget.controller.value.isPlaying ?? false;
  @override
  void initState() {
    super.initState();
    widget.controller..addListener(videoPlayerListener) ..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    /// Remove listener from the widget.controller and dispose it when widget dispose.
    /// 部件销毁时移除控制器的监听并销毁控制器。
    widget.controller
      ..removeListener(videoPlayerListener)
      ..pause()
      ..dispose();
    super.dispose();
  }
  /// 播放器的监听方法
  void videoPlayerListener() {
    if (isControllerPlaying != isPlaying.value) {
      isPlaying.value = isControllerPlaying;
    }
  }

  /// Whether the player is playing.
  /// 播放器是否在播放
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  /// Callback for the play button.
  /// 播放按钮的回调
  ///
  /// Normally it only switches play state for the player. If the video reaches the end,
  /// then click the button will make the video replay.
  /// 一般来说按钮只切换播放暂停。当视频播放结束时，点击按钮将从头开始播放。
  Future<void> playButtonCallback(BuildContext context) async {
    if (isPlaying.value) {
      widget.controller.pause();
      return;
    }

    if (widget.controller.value.duration == widget.controller.value.position) {
      widget.controller
        ..seekTo(Duration.zero)
        ..play();
      return;
    }
    widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),
        ),
        Positioned(bottom: 10,left: 0,right: 0,child:         VideoProgressIndicator(widget.controller, allowScrubbing: true),),
        ValueListenableBuilder<bool>(
          valueListenable: isPlaying,
          builder: (_, bool value, __) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              playButtonCallback(context);
            },
            child: Center(
              child: AnimatedOpacity(
                duration: kThemeAnimationDuration,
                opacity: value ? 0.0 : 1.0,
                child: GestureDetector(
                  onTap: () {
                    playButtonCallback(context);
                  },
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: Colors.black12),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      value
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_filled,
                      size: 70.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}