import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier{
  bool isCustomer = true;
  bool dataShared = false;
  List<Map<String, dynamic>> messages = [];

  toggleCustomer(){
    isCustomer = !isCustomer;
    notifyListeners();
  }
  void init(){
    Firestore.instance.collection('machines').document("weiss").stream.listen((event) {
      print(event);
      print(event?.map);
      dataShared = event?.map["shared"] ?? false;
      messages = List<Map<String,dynamic>>.from(event?.map["messages"] ?? []);
      notifyListeners();
    });
  }
  void shareData(List<Map<String, dynamic>> messages){
    Firestore.instance.collection('machines').document("weiss").set({"shared":true, "messages": messages});
  }
  void removeData(List<Map<String, dynamic>> messages){
    Firestore.instance.collection('machines').document("weiss").set({"shared":false, "messages": [{}]});
  }
}