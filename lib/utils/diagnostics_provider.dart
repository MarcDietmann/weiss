import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:weiss_app/utils/mqtt_provider.dart';

class DiagnosticsProvider extends ChangeNotifier {
  MQTTProvider? mqttProvider;
String voltageTopic = "voltage";
String vibrationTopic = "vibration";
String temperatureTopic = "Wallduern/Hackathon/TC150T/DeviceProperties/Temperature_processed";
String totalCycleTopic = "cycle";

List<String> topics = [];

void init(){
  for(String topic in topics){
    mqttProvider!.subscribeToTopic(topic, (msg) => safeData(topic, msg));
  }
}

void safeData(String topic, MqttMessage msg){

}
}