import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:x_design/xd_design.dart';
class TokenRefreshTest extends StatefulWidget {
  const TokenRefreshTest({super.key});

  @override
  State<TokenRefreshTest> createState() => _TokenRefreshTestState();
}

class _TokenRefreshTestState extends State<TokenRefreshTest> {
  late Dio dio;
  String accessToken="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkMTRmY2RkYTYyZmM0MDU2OTA4NDZkMTlmZGVkMDJlYSIsIm5hbWVpZCI6IjEzMzMiLCJuYmYiOjE3NDMyMTk4MTQsImV4cCI6MTc0MzIxOTg3NCwiaXNzIjoieGluZmFuZ3dlaSIsImF1ZCI6Im1hbmFnZXIifQ.ANnBSrLeQf-gO-5ANJM9x2oS7AjuKOiehpIjisjGKAk";
  String refreshToken="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1NDdlNzk2MTcwMmQ0OWRlYTY1NzMwYjc2NjhmNmZkOCIsIm5hbWVpZCI6IjEzMzMiLCJuYmYiOjE3NDMyMjA3NjUsImV4cCI6MTc0MzIyMDg4NSwiaXNzIjoieGluZmFuZ3dlaSIsImF1ZCI6Im1hbmFnZXIifQ.TMX9_1L5I17T8bAYXPY1hYB2GXzBxTgUL9yympHzsk8";
  @override
  void initState() {
    super.initState();
    dio=Dio(BaseOptions(

      baseUrl: "http://192.168.0.220:8188",
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.json.value,
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    ));
    var token=InMemoryTokenStorage<OAuth2Token>();
    token.write(OAuth2Token(accessToken: accessToken,refreshToken: refreshToken));
    dio.interceptors.add(
      Fresh.oAuth2(
        tokenStorage: token,
        refreshToken: (token, client) async {
         var r=await dio.get("/api/account/token/refresh?refreshToken=$refreshToken");
          return OAuth2Token(accessToken: r.data["accessToken"],refreshToken: r.data["refreshToken"]);
        },
      ),
    );
    dio.interceptors.add(XDDioLoggerInterceptor(XDLoggerServiceDefault()));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(title: const Text("token刷新测试")),body: Center(child:XDButton(child: const Text("token刷新测试"),onClick: (){
      dio.get("/api/account/me");
      dio.get("/api/account/me");
    },)));
  }
}
