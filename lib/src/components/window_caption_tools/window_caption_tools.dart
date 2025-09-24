// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';
//
// ///window窗口工具
// class WindowCaptionTools extends StatelessWidget  {
//   final Brightness? brightness;
//   const WindowCaptionTools({super.key,this.brightness});
//
//   @override
//   Widget build(BuildContext context) {
//     ///web端和移动端不显示
//     if(kIsWeb || Platform.isIOS || Platform.isAndroid) return const SizedBox();
//     return   Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//
//         WindowCaptionButton.minimize(
//           brightness: brightness,
//           onPressed: () async {
//             bool isMinimized = await windowManager.isMinimized();
//             if (isMinimized) {
//               windowManager.restore();
//             } else {
//               windowManager.minimize();
//             }
//           },
//         ),
//         //全屏
//          WindowCaptionScale(
//           brightness: brightness,
//         ),
//         //关闭
//         WindowCaptionButton.close(
//           brightness: brightness,
//           onPressed: () {
//             windowManager.close();
//             windowManager.destroy();
//           },
//         ),
//       ],
//     );
//   }
//
//
// }
//
// class WindowCaptionScale extends StatefulWidget {
//   final Color? backgroundColor;
//   final Brightness? brightness;
//   const WindowCaptionScale({super.key, this.backgroundColor, this.brightness});
//
//   @override
//   State<WindowCaptionScale> createState() => _XGisWindowCaptionScaleState();
// }
//
// class _XGisWindowCaptionScaleState extends State<WindowCaptionScale>
//     with WindowListener {
//   @override
//   void initState() {
//     windowManager.addListener(this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     windowManager.removeListener(this);
//     super.dispose();
//   }
//
//   @override
//   void onWindowMaximize() {
//     setState(() {});
//   }
//
//   @override
//   void onWindowUnmaximize() {
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: windowManager.isMaximized(),
//       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//         if (snapshot.data == true) {
//           return WindowCaptionButton.unmaximize(
//             brightness: widget.brightness,
//             onPressed: () {
//               windowManager.unmaximize();
//             },
//           );
//         }
//         return WindowCaptionButton.maximize(
//           brightness: widget.brightness,
//           onPressed: () {
//             windowManager.maximize();
//           },
//         );
//       },
//     );
//   }
// }