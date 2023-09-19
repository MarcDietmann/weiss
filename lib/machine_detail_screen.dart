import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weiss_app/utils/diagnostics_provider.dart';
import 'package:weiss_app/widgets/diagnostics_list.dart';
import 'package:weiss_app/widgets/helper_chat.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

import '2022/constants.dart';

class MachineDetailScreen extends StatelessWidget {
  const MachineDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: TCMachineCard(),
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
                padding:
                    const EdgeInsets.all(48.0).copyWith(top: 0, bottom: 16),
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
              ),
              Padding(
                padding: const EdgeInsets.all(48.0).copyWith(top: 0),
                child: RoundedContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Data", style: kSubHeadingStyle),
                        SfCartesianChart(
                          primaryXAxis:
                              DateTimeAxis(title: AxisTitle(text: 'Time')),
                          primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Temperature')),
                          series: [
                            LineSeries<Map, DateTime>(
                              dataSource:
                                  Provider.of<DiagnosticsProvider>(context)
                                      .getData(
                                          DiagnosticsProvider.temperatureTopic),
                              xValueMapper: (Map data, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data["julian_timestamp"]),
                              yValueMapper: (Map data, _) =>
                                  data["temperature"],
                              name: 'Temperature',
                              markerSettings: MarkerSettings(isVisible: true),
                            )
                          ],
                        ),
                        SfCartesianChart(
                          primaryXAxis:
                              DateTimeAxis(title: AxisTitle(text: 'Time')),
                          primaryYAxis:
                              NumericAxis(title: AxisTitle(text: 'vibration')),
                          series: [
                            LineSeries<Map, DateTime>(
                              dataSource: Provider.of<DiagnosticsProvider>(
                                      context)
                                  .getData(DiagnosticsProvider.vibrationTopic),
                              xValueMapper: (Map data, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data["julian_timestamp"]),
                              yValueMapper: (Map data, _) => data["adxlX"]
                                  ["Key Values"]["peak_high_frequency"],
                              name: 'Vibration',
                              markerSettings: MarkerSettings(isVisible: true),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        title: 'Chat with AI',
                      )));
        },
        label: Text("Hilfe Chat",style: kSubHeadingStyle,),
        icon: Icon(Icons.chat),
        backgroundColor: kYellow,
      ),
    );
  }
}

class TCMachineCard extends StatelessWidget {
  final bool onDetailScreen;
  const TCMachineCard({
    super.key, this.onDetailScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    double height = onDetailScreen?double.infinity:200;
    return Container(
      height: height,
      child: GestureDetector(
        onTap: () {
          if(onDetailScreen)return;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MachineDetailScreen()));
        },
        child: Hero(
          tag: "machine",
          child: Material(
            child: RoundedContainer(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TC Rundschalttisch", style: kHeadingStyle),
                        Text("ROBUST. ZUVERLÄSSIG. VIELSEITIG.",
                            style: kTextStyle),
                        Text("", style: kTextStyle),
                        Text("621242 - Walldürn", style: kTextStyle),
                        Text("Nächste Reperatur: 20.12.2024",
                            style: kSubHeadingStyle),
                      ],
                    ),
                    // Spacer(
                    //   flex: 2,
                    // ),
                    Image.asset(
                      "assets/images/tc320t.png",
                      height: min(200,height*0.7),
                    ),
                    onDetailScreen?SizedBox():StatusDisplay(small: !onDetailScreen,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusDisplay extends StatelessWidget {
  final MachineStatus? status;
  final bool small;
  const StatusDisplay({super.key, this.status,  this.small = false});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    if (status == MachineStatus.bad) {
      color = Colors.red;
    } else if (status == MachineStatus.warning) {
      color = Colors.yellow;
    }
    double height = small?100:250;

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
                  height: height,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: small?5:10,
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
                  size: small?50:100
                )
              ],
            ),
            Text(
              "${status == MachineStatus.bad ? "Schlecht" : status == MachineStatus.warning ? "Warnung" : "Gut"}",
              style: small?kSubHeadingStyle:kHeadingStyle,
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
