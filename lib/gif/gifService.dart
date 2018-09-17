import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gif/gif/gif.dart';
import 'package:http/http.dart' as http;

class GifService {

  static const String url = "http://api.giphy.com/v1/gifs/random?api_key=";
  String apiKey = "";

  Future<Gif> fetchImageUrlAsync(String tag, String rating) async {
    if (apiKey.isEmpty) {
      apiKey = await rootBundle.loadString("api_key");
    }
    var requestEndpoint = "$url$apiKey&tag=$tag&rating=$rating";
    final response = await http.get(requestEndpoint);
    if (response.statusCode == 200) {
      return Gif.fromJson(json.decode(response.body));
    }
    return null;
  }
}

