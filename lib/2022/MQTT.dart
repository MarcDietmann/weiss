/*
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:weiss_app/url_input.dart';

class mqtt_class {
  static int boolCounter = 0;

  static Future<Map<String, String>> EF3MapHelper() async {
    Map<String, String> map = {};
    MqttServerClient client =
    MqttServerClient.withPort('192.168.1.31', 'pepepe', 1883);
    client.keepAlivePeriod = 5;
    client.onConnected =
        () => print("Connected ${DateTime.now().millisecondsSinceEpoch}");
    client.onDisconnected =
        () => print("Disconnected ${DateTime.now().millisecondsSinceEpoch}");
    await client.connect();
    client.subscribe("/EF3/KPI/CycleCount", MqttQos.atLeastOnce);
    client.subscribe("/EF3/DeviceProperties/Timestamp_ms", MqttQos.atLeastOnce);
    client.subscribe(
        "/EF3/Process/EffectiveCurrent_A/DuringCycle", MqttQos.atLeastOnce);
    client.subscribe(
        "/EF3/Process/EffectiveCurrent_A/MaxLastCycle", MqttQos.atLeastOnce);
    client.subscribe(
        "/EF3/Process/EffectiveCurrent_A/RmsLastCycle", MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      MqttPublishMessage? pubMsg = c[0].payload as MqttPublishMessage?;
      String topic = c[0].topic;
      String content =
      MqttPublishPayload.bytesToStringAsString(pubMsg!.payload.message);
      switch (topic) {
        case "/EF3/KPI/CycleCount":
          boolCounter++;
          map['cycleCount'] = content;
          break;
        case "/EF3/DeviceProperties/Timestamp_ms":
          boolCounter++;
          map['timeSinceStartInSec'] = '${int.parse(content) / 1000}';
          break;
        case "/EF3/Process/EffectiveCurrent_A/DuringCycle":
          map['CurrentAmperDuringCycle'] = content;
          break;
        case "/EF3/Process/EffectiveCurrent_A/MaxLastCycle":
          boolCounter++;
          map['MaxAmperLastCycle'] = content;
          break;
        case "/EF3/Process/EffectiveCurrent_A/RmsLastCycle":
          boolCounter++;
          map['RmsAmperLastCycle'] = content;
          break;
      }
      if (boolCounter == 5) {
        client.disconnect();
      }
    });
    return map;
  }

  Future<Map<String, String>> getEF3Map() async {
    var testMap = await mqtt_class.EF3MapHelper();
    await Future.delayed(const Duration(milliseconds: 1000));
    return testMap;
  }
}*/



import 'package:flutter/material.dart';
import 'package:weiss_app/2022/url_input.dart';

class MQTT extends StatelessWidget {
  const MQTT({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStack(
        child: Center(
          child: Text(
              "UPS. Das ist keine Schleichwerbung, hier feht noch was."),
        ),
      ),
    );
  }
}