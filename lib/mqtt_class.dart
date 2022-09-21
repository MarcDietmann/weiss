/*import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void connect() async {
  MqttServerClient client =
  MqttServerClient.withPort('tcp://192.168.1.031', 'flutter_client', 1883);
  client.connect();
  client.subscribe("/EF3/KPI/CycleCount", MqttQos.atLeastOnce);
  client.updates.listen((event) { });
  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c ) {
    print(c);
  }
}*/
