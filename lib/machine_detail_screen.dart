import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weiss_app/utils/customer_provider.dart';
import 'package:weiss_app/utils/diagnostics_provider.dart';
import 'package:weiss_app/utils/llm_wrapper.dart';
import 'package:weiss_app/utils/mqtt_provider.dart';
import 'package:weiss_app/widgets/chat_messages.dart';
import 'package:weiss_app/widgets/diagnostics_list.dart';
import 'package:weiss_app/widgets/helper_chat.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

import '2022/constants.dart';

class MachineDetailScreen extends StatelessWidget {
  const MachineDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                            child: TCMachineCard(
                              isCustomer: Provider.of<CustomerProvider>(context)
                                  .isCustomer,
                            ),
                          ),
                        ),
                        StatusDisplay(
                          status: Provider.of<DiagnosticsProvider>(context)
                              .getTotalMachineStatus(),
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
                          errorList: Provider.of<DiagnosticsProvider>(context)
                              .getMachineStatuses(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Provider.of<CustomerProvider>(context).isCustomer
                  ? SizedBox()
                  : Datendetails(),
              Provider.of<CustomerProvider>(context).isCustomer
                  ? SizedBox()
                  : ChatHistory(
                      messages: context.watch<CustomerProvider>().messages,
                    ),
            ],
          ),
        ],
      ),
      floatingActionButton: !Provider.of<CustomerProvider>(context).isCustomer
          ? SizedBox()
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              title: 'Chat with Weiss AI Wizard',
                            )));
              },
              label: Text(
                "Weiss AI Wizard",
                style: kSubHeadingStyle,
              ),
              icon: Icon(Icons.chat),
              backgroundColor: kYellow,
            ),
    );
  }
}

class Datendetails extends StatelessWidget {
  const Datendetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0).copyWith(top: 0,bottom: 16),
      child: RoundedContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Datendetails", style: kSubHeadingStyle),
              Chart(
                title: "Temperatur",
                topic: DiagnosticsProvider.temperatureTopic,
                ytitle: "Grad Celsius",
                mapping: (
                  Map data,
                ) =>
                    ((data["temperature"] ?? 40.0) as double),
              ),
              Chart(
                  title: "Spannung - max",
                  topic: DiagnosticsProvider.maxVoltageLastCycleTopic,
                  ytitle: "Ampere",
                  mapping: (
                    Map data,
                  ) =>
                      (data["MaxLastCycle"] as double)),
              Chart(
                  title: "Zeit pro Umdrehung",
                  topic: DiagnosticsProvider.turnTimeTopic,
                  ytitle: "Millisekunden",
                  mapping: (
                    Map data,
                  ) =>
                      ((data["CycleTimeSensorLowToSensorHigh"] ?? 0) as int)
                          .toDouble()),
              Chart(
                  title: "Vibration",
                  topic: DiagnosticsProvider.vibrationTopic,
                  ytitle: "",
                  mapping: (
                    Map data,
                  ) =>
                      (data["adxlX"]["Key Values"]["peak_high_frequency"]
                          as double)),
              SizedBox(
                height: 8,
              ),
              RoundedContainer(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add,
                        size: 48,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Weitere Diagramme einbinden",
                        style: kSubHeadingStyle,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatHistory extends StatelessWidget {
  final List messages;
  const ChatHistory({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0).copyWith(top: 0),
      child: RoundedContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Wizard Chatverlauf", style: kSubHeadingStyle),
                Column(
                  children: [
                    for (int index = 0; index < messages.length + (context.read<LLMWrapper>().loading ? 1 : 0); index++)
                      if (index == messages.length)
                        Container(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        ChatMessage.fromMap(messages[index]),
                  ],
                ),

              ]),
        ),
      ),
    );
  }
}

class TCMachineCard extends StatelessWidget {
  final bool isCustomer;
  final bool onDetailScreen;
  const TCMachineCard({
    super.key,
    this.onDetailScreen = true,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    double height = onDetailScreen ? double.infinity : 220;
    return Container(
      height: height,
      child: GestureDetector(
        onTap: () {
          if (onDetailScreen) return;
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
                        !onDetailScreen
                            ? SizedBox()
                            : Text("", style: kTextStyle),
                        Text("Seriennummer: TC320T", style: kTextStyle),
                        Text("74731 - Walldürn", style: kTextStyle),
                        !onDetailScreen
                            ? SizedBox()
                            : Text("", style: kTextStyle),
                        Text("Nächste Reparatur vorraussichtlich: 01.10.2031",
                            style: kSubHeadingStyle),
                        !onDetailScreen
                            ? SizedBox()
                            : Text(
                                "Gesamte Umdrehungen: ${Provider.of<DiagnosticsProvider>(context).getLatestValue(DiagnosticsProvider.totalCycleTopic)["CycleCount"]}",
                                style: kTextStyle),
                        !onDetailScreen
                            ? SizedBox()
                            : Text("Montage: 01.10.2011", style: kTextStyle),
                        !onDetailScreen
                            ? SizedBox()
                            : Text("Letzte Reperatur: 22.06.2022",
                                style: kTextStyle),
                        Spacer(),
                        !onDetailScreen
                            ? SizedBox()
                            : TextButton(
                                onPressed: () {
                                  launchUrlString(
                                      "https://www.weiss-world.com/de-de/products/rundschalttische-44/rundschalttisch-45");
                                },
                                child: Text("Dokumentation",
                                    style: kSubHeadingStyle.copyWith(
                                        color: Colors.blue))),
                      ],
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !onDetailScreen
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!isCustomer) return;
                                    bool? val = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                  "Daten mit dem Support teilen"),
                                              content: Text(
                                                  "Um den Support zu kontaktieren, müssen Sie Ihre Daten mit dem Support teilen. Sind Sie damit einverstanden?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                    child: Text(
                                                      "Abbrechen",
                                                      style: kTextStyle,
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Provider.of<CustomerProvider>(
                                                              context,
                                                              listen: false)
                                                          .shareData(Provider
                                                                  .of<LLMWrapper>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .messages);
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: Text("Senden")),
                                              ],
                                            ));
                                    if (val == true) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                    "Daten wurden gesendet"),
                                                content: Text(
                                                    "Der Support wird sich innerhalb von 15 minuten bei ihnen melden."),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, false);
                                                      },
                                                      child: Text("Okay")),
                                                ],
                                              ));
                                    }
                                  },
                                  child: RoundedContainer(
                                    color: kYellow,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "${isCustomer ? "Support" : "Kunden"} kontaktieren",
                                            style: kSubHeadingStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Spacer(),
                        Image.asset(
                          "assets/images/tc320t.png",
                          height: min(200, height * 0.7),
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    onDetailScreen
                        ? SizedBox()
                        : StatusDisplay(
                            small: !onDetailScreen,
                            status: Provider.of<DiagnosticsProvider>(context)
                                .getTotalMachineStatus(),
                          ),
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

class Chart extends StatelessWidget {
  final String title;
  final String topic;
  final double Function(Map) mapping;
  final String ytitle;
  const Chart({
    Key? key,
    required this.title,
    required this.topic,
    required this.mapping,
    required this.ytitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4, right: 4),
      child: RoundedContainer(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: kSubHeadingStyle),
                  Spacer(),
                  Icon(Icons.close, color: Colors.grey),
                ],
              ),
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(title: AxisTitle(text: "Zeit")),
                primaryYAxis:
                    NumericAxis(title: AxisTitle(text: ytitle), plotBands: [
                  PlotBand(
                    isVisible: true,
                    start: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, true, false),
                    end: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, false, false),
                    color: Colors.green[100]!, // green color for good range
                    text: 'Good',
                    textStyle: kTextStyle.copyWith(color: Colors.black),
                  ),
                  PlotBand(
                    isVisible: true,
                    start: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, true, false),
                    end: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, true, true),
                    color: Colors.yellow[100]!, // green color for good range
                    text: 'Warning',
                    textStyle: kTextStyle.copyWith(color: Colors.black),
                  ),
                  PlotBand(
                    isVisible: true,
                    start: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, false, true),
                    end: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, false, false),
                    color: Colors.yellow[100]!, // green color for good range
                    text: 'Warning',
                    textStyle: kTextStyle.copyWith(color: Colors.black),
                  ),
                  PlotBand(
                    isVisible: true,
                    start: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, true, true),
                    end: -double.infinity,
                    color: Colors.red[100]!, // green color for good range
                    text: 'Bad',
                    textStyle: kTextStyle.copyWith(color: Colors.black),
                  ),
                  PlotBand(
                    isVisible: true,
                    start: double.infinity,
                    end: Provider.of<DiagnosticsProvider>(context)
                        .getRangeValue(topic, false, true),
                    color: Colors.red[100]!, // green color for good range
                    text: 'Bad',
                    textStyle: kTextStyle.copyWith(color: Colors.black),
                  ),
                ]),
                series: [
                  LineSeries<Map, DateTime>(
                    dataSource: Provider.of<DiagnosticsProvider>(context)
                        .getData(topic),
                    xValueMapper: (Map data, _) =>
                        DateTime.fromMillisecondsSinceEpoch(
                            data["julian_timestamp"] ??
                                DateTime(2023, 1, 1).millisecondsSinceEpoch),
                    yValueMapper: (Map data, _) => mapping(data),
                    name: title,
                    markerSettings: MarkerSettings(isVisible: true),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusDisplay extends StatelessWidget {
  final MachineStatusLevel? status;
  final bool small;
  const StatusDisplay({super.key, this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    if (status == MachineStatusLevel.bad) {
      color = Colors.red;
    } else if (status == MachineStatusLevel.warning) {
      color = Colors.yellow;
    }
    double height = small ? 100 : 250;

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
                        strokeWidth: small ? 5 : 10,
                        value: 1,
                        color: color,
                      ),
                    ),
                  ),
                ),
                Icon(
                    status == MachineStatusLevel.bad
                        ? Icons.heart_broken_sharp
                        : status == MachineStatusLevel.warning
                            ? Icons.warning
                            : Icons.gpp_good,
                    color: color,
                    size: small ? 50 : 100)
              ],
            ),
            Text(
              "${status == MachineStatusLevel.bad ? "Schlecht" : status == MachineStatusLevel.warning ? "Warnung" : "Gut"}",
              style: small ? kSubHeadingStyle : kHeadingStyle,
            )
          ],
        ),
      ),
    );
  }
}

enum MachineStatusLevel {
  good,
  warning,
  bad,
}
