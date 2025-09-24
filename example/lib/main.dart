import 'package:example/token_refresh_test.dart';
import 'package:flutter/material.dart';
import 'package:x_design/xd_design.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        XDFileUtil.viewFiles<String>(context, [
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          "https://www.shutterstock.com/shutterstock/photos/2419249527/display_1500/stock-photo-woman-screaming-through-megaphone-in-front-of-turquoise-brick-wall-2419249527.jpg",
        "http://www.baidu.com"
        ], 0);
      }),
      appBar: AppBar(),
      body: Wrap(
        children: [
          XDButton(
              child: Text(
                "测试token刷新",
              ),
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TokenRefreshTest()));
              })
        ],
      ),
    );
  }
}
