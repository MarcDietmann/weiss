import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier{
  bool isCustomer = true;

  toggleCustomer(){
    isCustomer = !isCustomer;
    notifyListeners();
  }
}