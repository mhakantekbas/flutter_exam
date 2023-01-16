import 'dart:convert';

import 'package:flutter_exam/NewsModel.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  static Future<List<NewsModel>> getDataByQuery({String q = "top"}) async {
    List<NewsModel> books = [];
    var url =
        'https://newsdata.io/api/1/news?apikey=pub_15697089ded362b62228ab60237f45d1ed997&country=gb&category=$q ';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    print('api started');

    if (books is List) {
      books = results.map((e) => NewsModel.fromMap(e)).toList();
    } else {
      return [];
    }
    return books;
  }
}
