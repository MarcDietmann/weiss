import 'package:flutter/material.dart';
import 'package:weiss_app/widgets/diagnostics_list.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

import '2022/constants.dart';

class MachineDetailScreen extends StatelessWidget {
  const MachineDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(48.0).copyWith(bottom: 16),
                child: Container(
                  height: 400,
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: RoundedContainer(
                              height: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 300,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("TC Rundschalttisch",
                                              style: kHeadingStyle),
                                          Text(
                                              "ROBUST. ZUVERLÄSSIG. VIELSEITIG.",
                                              style: kTextStyle),
                                          Text(
                                              "",
                                              style: kTextStyle),

                                          Text(
                                              "621242 - Walldürn",
                                              style: kTextStyle),
                                          Text("Nächste Reperatur: 20.12.2024", style: kSubHeadingStyle),

                                        ],
                                      ),
                                    ),
                                    // Spacer(
                                    //   flex: 2,
                                    // ),
                                    Image.asset(
                                      "assets/images/tc320t.png",
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        StatusDisplay(
                          status: MachineStatus.good,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(48.0).copyWith(top: 0),
                child: RoundedContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status anzeigen:",
                          style: kSubHeadingStyle,
                        ),
                        DiagnosticsList(
                          errorList: [
                            {
                              "name": "Temperatur",
                              "message": "Perfekt - 42°C",
                              "level": 0
                            },
                            {
                              "name": "Vibration",
                              "message": "Warnung - 23% stärker als normal",
                              "level": 1
                            },
                            {
                              "name": "Voltage",
                              "message": "Das ist ein Fehler",
                              "level": 2
                            },
                            {
                              "name": "Umdrehungsanzahl",
                              "message": "Perfekt",
                              "level": 0
                            }
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class StatusDisplay extends StatelessWidget {
  final MachineStatus? status;
  const StatusDisplay({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    if (status == MachineStatus.bad) {
      color = Colors.red;
    } else if (status == MachineStatus.warning) {
      color = Colors.yellow;
    }

    return RoundedContainer(
      color: color.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Status",
              style: kSubHeadingStyle,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        value: 1,
                        color: color,
                      ),
                    ),
                  ),
                ),
                Icon(
                  status == MachineStatus.bad
                      ? Icons.heart_broken_sharp
                      : status == MachineStatus.warning
                          ? Icons.warning
                          : Icons.gpp_good,
                  color: color,
                  size: 100,
                )
              ],
            ),
            Text(
              "${status == MachineStatus.bad ? "Schlecht" : status == MachineStatus.warning ? "Warnung" : "Gut"}",
              style: kHeadingStyle,
            )
          ],
        ),
      ),
    );
  }
}

enum MachineStatus {
  good,
  warning,
  bad,
}
