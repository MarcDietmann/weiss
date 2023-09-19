import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:weiss_app/utils/mqtt_provider.dart';

class DiagnosticsProvider extends ChangeNotifier {
  MQTTProvider? mqttProvider;
  static String voltageTopic = "voltage";
  static String vibrationTopic = "Wallduern/Hackathon/TC150T/DeviceProperties/Vibration_processed";
  static String temperatureTopic =
      "Wallduern/Hackathon/TC150T/DeviceProperties/Temperature_processed";
  String totalCycleTopic = "cycle";

  List<String> topics = [];

  Map<String, List<Map>> _data = {};

  // {
  //   "Wallduern/Hackathon/TC150T/DeviceProperties/Temperature_processed": [
  //     {"temperature": 41.795580110497234, "UTC Timestamp": 1695150220}
  //   ]
  // };

  void init() {
    topics = [temperatureTopic,vibrationTopic];
    for (String topic in topics) {
      mqttProvider!.subscribeToTopic(topic, (msg) => safeData(topic, msg));
    }
  }

  void safeData(String topic, MqttReceivedMessage<MqttMessage?> msg) {
      String payload = MQTTProvider.getPayload(msg);
      if (_data[topic] == null) _data[topic] = [];
      Map data = jsonDecode(payload);
      data["julian_timestamp"] = DateTime.now().millisecondsSinceEpoch;
      _data[topic]?.add(data);
      notifyListeners();
    print("Data: $_data");
  }

  List<Map> getData(String topic) {
    return _data[topic] ?? [];
  }
}
