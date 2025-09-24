

import 'package:dio/dio.dart';
///百度的文心一言
///https://cloud.baidu.com/doc/WENXINWORKSHOP/s/clntwmv7t
///BaiduWenxinyiyan(apiKey: "282bVwuyYC9ki2PM3BKyt295", secretKey: "dtcuSnuIHCszgjLkaGh3hJ1t9YJnEZr6").chat("武汉今天天气怎么样");
class BaiduWenxinyiyan{
  String? _accessToken="24.448f921a8aeea00de53dff705da3cbd5.2592000.1714618748.282335-59361925";
  final String  apiKey;
  final String secretKey;
  BaiduWenxinyiyan({required this.apiKey,required this.secretKey});
  Future<String> _fetchAccessToken() async {
    // 创建dio实例
    Dio dio = Dio();

    // 构建请求体参数
    var data = {
      "grant_type": "client_credentials",
      "client_id": apiKey,
      "client_secret": secretKey
    };

    try {
      // 发送HTTP POST请求
      var response = await dio.get(
        "https://aip.baidubce.com/oauth/2.0/token",
        options: Options(headers: {"Content-Type": "application/json"}),
        data: data,
      );

      // 解析响应
      if (response.statusCode == 200) {
        // 如果响应成功，解析JSON并返回access_token
        return response.data["access_token"];
      } else {
        // 如果响应失败，抛出异常
        throw Exception("Failed to fetch access token");
      }
    } catch (e) {
      // 捕获任何异常并抛出
      throw Exception("Error: $e");
    }
  }

  Future<String?> chat( String prompt) async {
    Dio dio = Dio();
    try {
      _accessToken??=await _fetchAccessToken();
      var response = await dio.post(
        'https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/completions_pro',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Charset': 'UTF-8',
        }),
        data: {
          "messages": [
            {"role": "user", "content": prompt}
          ]
        },
        queryParameters: {'access_token': _accessToken},
      );
      if (response.statusCode == 200) {
        return response.data["result"];
      } else {
        throw Exception('Failed to call API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


}