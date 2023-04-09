import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_chargpt_chat/constants/api_consts.dart';
import 'package:flutter_chargpt_chat/models/chat_model.dart';
import 'package:flutter_chargpt_chat/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var responce = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {"Authorization": "Bearer $apiUrl"},
      );
      Map jsonResponce = jsonDecode(responce.body);
      if (jsonResponce['error'] != null) {
        throw HttpException(jsonResponce['error']['message']);
      }
      List temp = [];
      for (var value in jsonResponce["data"]) {
        temp.add(value);
      }
      return ModelsModel.modelFromsSnapshot(temp);
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var respPost = await http.post(
        Uri.parse("$baseUrl/completions"),
        headers: {
          "Authorization": "Bearer $apiUrl",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 100,
          },
        ),
      );
      Map jsonTextPost = jsonDecode(utf8.decode(respPost.bodyBytes));
      if (jsonTextPost['error'] != null) {
        throw HttpException(jsonTextPost['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonTextPost["choices"].length > 0) {
        chatList = List.generate(
          jsonTextPost["choices"].length,
          (index) => ChatModel(
              msg: jsonTextPost['choices'][index]["text"], chatIndex: 1),
        );
      }
      return chatList;
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessageTurboGPT(
      {required String message, required String modelId}) async {
    try {
      var respPost = await http.post(
        Uri.parse("$baseUrl/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiUrl",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ],
          },
        ),
      );
      Map jsonTextPost = jsonDecode(utf8.decode(respPost.bodyBytes));
      if (jsonTextPost['error'] != null) {
        throw HttpException(jsonTextPost['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonTextPost["choices"].length > 0) {
        chatList = List.generate(
          jsonTextPost["choices"].length,
          (index) => ChatModel(
              msg: jsonTextPost['choices'][index]['message']['content'],
              chatIndex: 1),
        );
      }
      return chatList;
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }
}
