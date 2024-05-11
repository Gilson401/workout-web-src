import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/home/controller/url_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController {
  HomeController({Key? key});

  Future<List<dynamic>> loadData() async {
    List<dynamic> decoded = [{}];
    try {
      http.Response response =
          await http.get(Uri.parse(UrlConstants.workoutApi));
      decoded = jsonDecode(response.body);
      
    } catch (err) {
      throw Exception(err.toString());
    }

    return decoded;
  }
}
