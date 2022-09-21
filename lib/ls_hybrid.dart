import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'classes.dart';
class HybridProvider extends ChangeNotifier{
  CyclicData? data;

  String url = "http://192.168.1.150/Hackathon2022/LSHybridJSON.asp";

  Future<void> getData(url) async {
    Response response = await get(Uri.parse(url));
    print(response.statusCode);
    Map body = jsonDecode(response.body);
    CyclicData data = CyclicData.fromJson(body["CyclicData"]);
    print(data.toString());
    notifyListeners();
  }
}