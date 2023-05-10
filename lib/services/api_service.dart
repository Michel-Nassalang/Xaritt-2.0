import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_consts.dart';
import '../models/chatgpt/chat_model.dart';
import '../models/chatgpt/models_model.dart';


class ApiService {

  //----------------------------------------------------------------
  // Recupérer la liste des modèles de chat répondant
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  //----------------------------------------------------------------
  // Envoyer une question et recupérer une reponse
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      Map jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }


  //----------------------------------------------------------------
  // Générer une image à partir d'un texte
  static Future<List<ChatModel>> generateImage(String prompt) async {
    final response = await http.post(Uri.parse('$BASE_URL/images/generations'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $API_KEY',
    }, body: json.encode({
      'model': 'image-alpha-001',
      'prompt': prompt,
      'num_images': 1,
      'size': '1024x1024',
    }));

    if (response.statusCode != 200) {
      throw Exception("Echec sur la génération d'image");
    }

    final data = json.decode(response.body)['data'][0];
    // return data['url'];
    List<ChatModel> chatList = [];
    chatList = List.generate(
      json.decode(response.body)['data'].length,
      (index) => ChatModel(
        msg: data['url'],
        chatIndex: 2,
      ),
    );
    return chatList;
  }

  //----------------------------------------------------------------
  
}
