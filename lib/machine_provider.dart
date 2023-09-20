
import 'package:flutter/cupertino.dart';
import 'package:weiss_app/machine_detail_screen.dart';

class MachineData extends ChangeNotifier{
  List<Widget> machines = [TCMachineCard(onDetailScreen: false, isCustomer: true,)];
  bool isAdding = false;

  void startAdding() {
    isAdding = true;
    notifyListeners();
  }

  addMachine(String ip, String type){
    machines.add(SizedBox(height: 16,));
    machines.add(TCMachineCard(onDetailScreen: false, isCustomer: true,));
    isAdding= false;
    notifyListeners();
    print(machines);
  }
}
