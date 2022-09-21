import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'classes.dart';
class HybridProvider extends ChangeNotifier{
  CyclicData? data;
  bool listening = false;

  String url = "http://192.168.1.150/Hackathon2022/LSHybridJSON.asp";

  Future<void> getData(url) async {
    Response response = await get(Uri.parse(url));
    print(response.statusCode);
    Map body = jsonDecode(response.body);
    data = CyclicData.fromJson(body["CyclicData"]);
    print(data.toString());
    notifyListeners();
  }

  Future<void> startListening(url)async {
    print("hello world");
    listening = true;
    notifyListeners();
    while(listening){
     getData(url);
     sleep(const Duration(seconds: 1));
    }
  }
  Future<void> endListening(url)async {
    listening = true;
    notifyListeners();
    while(listening){
     getData(url);
     // sleep(const Duration(seconds: 1));
    }
  }
}