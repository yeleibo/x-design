import 'dart:convert';

import 'package:dio/dio.dart';

///ChatGpt
///https://api.b3n.fun/token
///ChatGpt("sk-EYB77TQw1kv0kUDOCb479a0239854a17907637565266B346").chat("武汉今天天气怎么样")
class ChatGpt{
  // 设置API端点URL
  final String apiUrl = "https://api.b3n.fun/v1/chat/completions";
  final String apiKey;
  ChatGpt(this.apiKey) ;
  Future<String?> chat( String prompt,{String? model}) async {
    final dio = Dio();

      final response = await dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
        data: jsonEncode({
          "model": model??"gpt-4-turbo-preview",
          "messages": [
            {
              "role": "user",
              "content": prompt
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        return response.data["choices"][0]["message"]["content"];
      } else {
        throw Exception('Failed to post $apiUrl');
      }

  }
}