import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/2022/constants.dart';
import 'package:weiss_app/machine_provider.dart';
import 'package:weiss_app/utils/mqtt_provider.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

class OverviewScreen extends StatefulWidget {
  OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  var selectedDropdownValue = "Alle";
  List<String> dropdownValues = [
    "Alle",
    "Sortiert nach Unternehmen",
    "Sortiert nach Standort",
    "Sortiert nach Maschinenart",
    "Sortiert nach Reperaturdatum"
  ];

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
                      Image.asset(
                        "assets/images/logo_high_res.png",
                        height: 150,
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Spacer(),
                      DropdownButton<String>(
                          value: selectedDropdownValue,
                          items: dropdownValues
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (e) {
                            setState(() {
                              selectedDropdownValue = e.toString();
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          }),
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
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                GestureDetector(
                    onTap: () {
                      Provider.of<MQTTProvider>(context,listen: false).isConnected?
                      Provider.of<MQTTProvider>(context, listen: false).disconnect():
                      Provider.of<MQTTProvider>(context, listen: false).startConnection();
                    },
                    child: RoundedContainer(
                      color: Colors.blue,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                        child: Text(
                          Provider.of<MQTTProvider>(context).isConnected
                              ? "Trennen"
                              : "Verbinden",
                          style: kTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    )),Spacer(),
              ],
            ),
          )
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
  String _machineType = 'TC Rundschalttisch';
  String _customer = "Dr. Oetker";

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Kunde: "),
            ),
            DropdownButton<String>(
              value: _customer,
              items: ['Dr. Oetker', 'Wagner', 'Kunde 3', 'Kunde 4']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _customer = newValue!;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Maschine: "),
            ),
            DropdownButton<String>(
              value: _machineType,
              items: [
                'TC Rundschalttisch',
                'Maschine 2',
                'Maschine 3',
                'Maschine 4'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _machineType = newValue!;
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _addMachine,
          child: Text('Maschine hinzufügen'),
        ),
      ],
    );
  }
}
