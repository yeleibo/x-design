// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:x_design/src/utils/ai/baidu.dart';
import 'package:x_design/src/utils/extension/latlng_extension.dart';

import 'package:x_design/xd_design.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
 var r=  await LatLng(30, 114).addressFromGaode(gaodeMapKey: 'b69df5a43ec81b3343e37300e33859e4');
  print(r);
 var r2=  await LatLng(30, 114).addressFromTianditu(tiandituMapKey: '782cfa7e1b12cd72e0a3a8f09ab54f38');
 print(r2);
  });
  testWidgets('百度文心一言', (WidgetTester tester) async {
    var bd=BaiduWenxinyiyan(apiKey: "282bVwuyYC9ki2PM3BKyt295", secretKey: "dtcuSnuIHCszgjLkaGh3hJ1t9YJnEZr6");
    var r=await bd.chat("武汉今天天气怎么样");
    print(r);
  });
}
