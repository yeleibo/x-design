
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:printing/printing.dart';


///展示图片弹窗
// showPdfViewDialog(
//     {required BuildContext context,
//     String? pdfPath,
//     Uint8List? pdfBytes,
//     String? pdfName}) {
//   assert(pdfPath != null || pdfBytes != null);
//   showDialog(
//       context: context,
//       builder: (_) {
//         return XDDialog(
//           title: Text(pdfName ?? ''),
//           child:
//           // (Platform.isAndroid || Platform.isIOS)
//           //     ? FutureBuilder<Uint8List>(
//           //         future: pdfBytes != null
//           //             ? Future.value(pdfBytes)
//           //             : NetworkAssetBundle(Uri.parse(pdfPath!))
//           //                 .load("")
//           //                 .then((value) => value.buffer.asUint8List()),
//           //         builder: (context, snapshot) {
//           //           if (snapshot.connectionState == ConnectionState.waiting) {
//           //             return Center(
//           //               child: CircularProgressIndicator(),
//           //             );
//           //           } else {
//           //             if (snapshot.hasError) {
//           //               return Center(
//           //                 child: Text('文件加载出错'),
//           //               );
//           //             } else if (snapshot.hasData) {
//           //               return PDFView(
//           //                 pdfData: snapshot.data!,
//           //               );
//           //             }
//           //           }
//           //
//           //           return SizedBox();
//           //         },
//           //       )
//           //     :
//           PdfPreview(
//                   allowPrinting: false,
//                   allowSharing: false,
//                   canChangeOrientation: false,
//                   canChangePageFormat: false,
//                   canDebug: false,
//                   maxPageWidth: MediaQuery.of(context).size.width,
//                   build: (format) async {
//                     if (pdfBytes != null) {
//                       return pdfBytes;
//                     } else {
//                       return pdfPath!.getFileBytes();
//                     }
//                   }),
//         );
//       });
// }
