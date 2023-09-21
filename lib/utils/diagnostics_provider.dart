import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:weiss_app/machine_detail_screen.dart';
import 'package:weiss_app/utils/mqtt_provider.dart';

class DiagnosticsProvider extends ChangeNotifier {
  MQTTProvider? mqttProvider;
  static String maxVoltageLastCycleTopic =
      "EF3_010.001.070.005/Process/EffectiveCurrent_A/MaxLastCycle";
  static String vibrationTopic =
      "Wallduern/Hackathon/TC150T/DeviceProperties/Vibration_processed";
  static String temperatureTopic =
      "Wallduern/Hackathon/TC150T/DeviceProperties/Temperature_processed";
  static String totalCycleTopic = "EF3_010.001.070.005/KPI/CycleCount";
  static String turnTimeTopic =
      "EF3_010.001.070.005/Process/CycleTime/SensorLowToSensorHigh_ms";

  List<MachineStatus> machineStatuses = [];

  List<String> topics = [];
  static Map<String, Map<String, dynamic>> bounds = {
    temperatureTopic: {
      "min": 20,
      "max": 50,
      "cmin": 0,
      "cmax": 100,
      "low_waring": "Die Temperatur ist zu niedrig.",
      "high_warning": "Die Temperatur ist  zu hoch."
    },
    maxVoltageLastCycleTopic: {
      "min": 0.3,
      "max": 0.6,
      "cmin": 0,
      "cmax": 1,
      "low_waring": "Die Stromstärke ist zu niedrig.",
      "high_warning": "Die Stromstärke ist  zu hoch."
    },
    vibrationTopic: {
      "min": 0,
      "max": 30,
      "cmin": 0,
      "cmax": 60,
      "low_waring": "Die Vibration ist zu niedrig.",
      "high_warning": "Die Vibration ist zu hoch."
    },
    turnTimeTopic: {
      "min": 500,
      "max": 600,
      "cmin": 400,
      "cmax": 700,
      "low_waring": "Die Drehzeit ist zu niedrig.",
      "high_warning": "Die Drehzeit ist zu hoch."
    },
  };

  Map<String, List<Map>> _data = {
    temperatureTopic: [],
    vibrationTopic: [],
    totalCycleTopic: [],
    maxVoltageLastCycleTopic: [],
    turnTimeTopic: []
  };

  // {
  //   "Wallduern/Hackathon/TC150T/DeviceProperties/Temperature_processed": [
  //     {"temperature": 41.795580110497234, "UTC Timestamp": 1695150220}
  //   ]
  // };

  void init() {
    topics = [
      temperatureTopic,
      vibrationTopic,
      totalCycleTopic,
      maxVoltageLastCycleTopic,
      turnTimeTopic
    ];
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
    // print("Data: $_data");
  }

  List<Map> getData(String topic) {
    return _data[topic] ?? [];
  }

  Map getLatestValue(String topic) {
    if (_data[topic] == null) return {};
    if(_data[topic]!.isEmpty) return {};
    return _data[topic]!.last;
  }

  MachineStatusLevel getTotalMachineStatus() {
    if (machineStatuses
        .where((element) => element.level == MachineStatusLevel.bad)
        .isNotEmpty) return MachineStatusLevel.bad;
    if (machineStatuses
        .where((element) => element.level == MachineStatusLevel.warning)
        .isNotEmpty) return MachineStatusLevel.warning;
    return MachineStatusLevel.good;
  }

  List<MachineStatus> getMachineStatuses() {
    List<MachineStatus> statuses = [];
    statuses.add(getStatusForTopic(
        temperatureTopic, "Temperatur", "°C", (data) => data["temperature"]));
    statuses.add(getStatusForTopic(maxVoltageLastCycleTopic, "Stromstärke", "A",
        (data) => data["MaxLastCycle"]));
    statuses.add(getStatusForTopic(vibrationTopic, "Vibration", "",
        (data) => data["adxlX"]["Key Values"]["peak_high_frequency"]));
    statuses.add(getStatusForTopic(turnTimeTopic, "Dauer der Drehung", "ms", (data)=>(data["CycleTimeSensorLowToSensorHigh"] as int).toDouble()));
    machineStatuses = statuses;
    return statuses;
  }

  MachineStatus getStatusForTopic(
      String topic, String title, String unit, double Function(Map) formatter) {
    MachineStatus status = MachineStatus();
    Map latestValue = getLatestValue(topic);
    if (latestValue.isEmpty) return status;

    double value = formatter(latestValue);
    print("Latest Value: $latestValue");
    status.title = title;
    if (value < bounds[topic]?["min"]) {
      status.help = bounds[topic]?["low_waring"];
      status.level = MachineStatusLevel.warning;
    } else if (value > bounds[topic]?["max"]) {
      status.help = bounds[topic]?["high_warning"];
      status.level = MachineStatusLevel.warning;
    } else {
      status.help = "Alles in Ordnung";
      status.level = MachineStatusLevel.good;
    }
    if (value < bounds[topic]?["cmin"]) {
      status.help = bounds[topic]?["low_waring"];
      status.level = MachineStatusLevel.bad;
    } else if (value > bounds[topic]?["cmax"]) {
      status.help = bounds[topic]?["high_warning"];
      status.level = MachineStatusLevel.bad;
    }
    status.help = status.help + " (${value.toStringAsFixed(2)} $unit)";
    return status;
  }

  num getRangeValue(String topic, bool min, bool critical){
    if(min && critical) return bounds[topic]?["cmin"];
    if(min && !critical) return bounds[topic]?["min"];
    if(!min && critical) return bounds[topic]?["cmax"];
    if(!min && !critical) return bounds[topic]?["max"];
    return 0;
  }

  @override
  void dispose() {
    super.dispose();
    for (String topic in topics) {
      mqttProvider?.unsubscribeFromTopic(topic);
    }
  }
}

class MachineStatus {
  String title = "";
  String help = "";
  MachineStatusLevel level;

  MachineStatus(
      {this.title = "",
      this.help = "",
      this.level = MachineStatusLevel.warning});
}
