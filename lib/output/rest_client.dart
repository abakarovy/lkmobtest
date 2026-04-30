import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:lkmobileapp/output/http_overrides.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:http_auth/http_auth.dart';


class RestClient {

  final Map<String, BasicAuthClient> _clients = {};

  static RestClient? _instance;
  RestClient._(){
    HttpOverrides.global = PostHttpOverrides(); //Нужно чтоб игнорировать ssl
  }

  BasicAuthClient getNewClient(String login, String password){
    var client = http_auth.BasicAuthClient(login, password);
    if (_clients.containsKey(login)){
      _clients[login]?.close();
      _clients.remove(login);
      _clients.putIfAbsent(login, () => client);
    }else{
      _clients.putIfAbsent(login, () => client);
    }
    return client;
  }

  Future<dynamic> post(String login, Uri uri, Map<String, dynamic> jsonMapBody) async {
    if (_clients.containsKey(login)){
      var body = jsonEncode(jsonMapBody);
      var response = await _clients[login]!.post(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body
      );
      inspect(response);
      var jsonResultMap = jsonDecode(utf8.decode(response.bodyBytes));
      // if (jsonResultMap is Map<String, dynamic>){
      //    if (jsonResultMap.containsKey("error")){
      //      throw BGConnectException(jsonResultMap["error"]);
      //    }
      // }
      return jsonResultMap;
    }else{
      throw HttpClientNotFoundException('нет такого инициализированного клиента');
    }
  }

  Future<dynamic> get(String login, Uri uri) async {
    if (_clients.containsKey(login)){
      Response response = await _clients[login]!.get(uri);
      var jsonMap = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonMap is Map<String, dynamic>){
        if (jsonMap.containsKey("error")){
          throw BGConnectException(jsonMap["error"]);
        }
      }
      return jsonMap;
    }else{
      throw HttpClientNotFoundException('нет такого инициализированного клиента');
    }
  }

  Future<void> getWithoutResult(String login, Uri uri) async {
    if (_clients.containsKey(login)){
      await _clients[login]!.get(uri);
    }else{
      throw HttpClientNotFoundException('нет такого инициализированного клиента');
    }
  }

  BasicAuthClient getClient(String login){
    return _clients[login] ?? (throw Exception('нет такого инициализированного клиента'));
  }

  factory RestClient.getInstance() {
    _instance ??= RestClient._();
    return _instance!;
  }
}

class BGConnectException implements Exception{
  final String message;
  BGConnectException(this.message);
}

class HttpClientNotFoundException implements Exception{
  final String message;
  HttpClientNotFoundException(this.message);
}


