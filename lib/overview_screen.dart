import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/2022/constants.dart';
import 'package:weiss_app/machine_detail_screen.dart';
import 'package:weiss_app/machine_provider.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 100,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Maschinenübersicht",
                        style: kHeadingStyle.copyWith(fontSize: 80),
                      ),
                    ],
                  ),
                ),
                ...Provider.of<MachineData>(context, listen: true).machines,
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RoundedContainer(
                    height: 300,
                    width: 600,
                    child: AddMachineButton(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddMachineButton extends StatefulWidget {
  const AddMachineButton({
    super.key,
  });

  @override
  State<AddMachineButton> createState() => _AddMachineButtonState();
}

class _AddMachineButtonState extends State<AddMachineButton> {
  bool isAdding = false;
  @override
  Widget build(BuildContext context) {
    return Provider.of<MachineData>(context, listen: true).isAdding
        ? MyWidget()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Provider.of<MachineData>(context, listen: false)
                        .startAdding();
                  },
                  child: Icon(
                    Icons.add_box_outlined,
                    size: 100,
                  ),
                ),
              ),
              Text(
                "Neue Maschine hinzufügen",
                style: kSubHeadingStyle.copyWith(fontSize: 20),
              ),
            ],
          );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _ipAddressController = TextEditingController();
  String _machineType = 'Typ 1';

  void _addMachine() {
    final String ipAddress = _ipAddressController.text;
    print("IP-Adresse: $ipAddress");
    print("Maschinenart: $_machineType");
    Provider.of<MachineData>(context, listen: false)
        .addMachine(ipAddress, _machineType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Neue Maschine hinzufügen",
          style: TextStyle(
              fontSize: 20), // Ersetzen Sie dies durch Ihren kSubHeadingStyle
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _ipAddressController,
            decoration: InputDecoration(labelText: 'IP-Adresse'),
          ),
        ),
        DropdownButton<String>(
          value: _machineType,
          items: ['Typ 1', 'Typ 2', 'Typ 3', 'Typ 4'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _machineType = newValue!;
              // Aktualisieren Sie den Bildpfad basierend auf dem ausgewählten Maschinentyp
              // _imagePath = ...;
            });
          },
        ),
        ElevatedButton(
          onPressed: _addMachine,
          child: Text('Maschine hinzufügen'),
        ),
      ],
    );
  }
}
