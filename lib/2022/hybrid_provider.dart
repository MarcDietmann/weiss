import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
// import 'package:get/utils.dart';
import 'package:http/http.dart';

import 'chart_page.dart';
import 'classes.dart';

class HybridProvider extends ChangeNotifier {
  CyclicData? data;
  bool? listening;
  List<LiveData> chartData=[];
  int index = 0;

  String url = "http://192.168.1.150/Hackathon2022/LSHybridJSON.asp";

  void init() {
    chartData = [];
    listening = false;
    index = 0;
    notifyListeners();
    print("init Hybrid");
  }

  Future<void> getData(url) async {
    try {
      Response response = await get(Uri.parse(url));
      print(response.statusCode);
      Map body = jsonDecode(response.body);
      data = CyclicData.fromJson(body["CyclicData"]);
      print(data);
      notifyListeners();
    } catch (e) {
      print("Error during getHybridData:");
      // e.printError();
    }
  }

  Future<void> startListening() async {
    listening = true;
    notifyListeners();
  }

  Future<void> stopListening() async {
    listening = false;
    notifyListeners();
  }

  Future<void> addLiveData(url) async {
    listening = true;
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (listening!) {
        getData(url);
      }
    });
  }
}


