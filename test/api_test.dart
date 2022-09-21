
/*Future<void> main2() async {
  String url = "http://192.168.1.150/Hackathon2022/LSHybridJSON.asp";
  Response response = await get(Uri.parse(url));
  Map body = jsonDecode(response.body);
  CyclicData data = CyclicData.fromJson(body["CyclicData"]);
  print(data.corner1!.axis0Position);
}*/

/*Future<void> main() async {
  var url =
      "http://192.168.11.235/getvar.cgi?var1=Application.UserVarGlobal.g_grWebView[2].MotorVelocity";
 // String test ="\u005B \u005D";
 // Map headers = {
 //   'Content-Type': 'application/json;charset=UTF-8',
 //   'Charset': 'utf-8'
 // };
 //  // Response response = await get(Uri.parse(url));
  // print(response.request);
  // print(response.body);
  // Uri URI = Uri(scheme: "http", path: "192.168.11.235/getvar.cgi",query: "var1=Application.UserVarGlobal.g_grWebView[2].MotorVelocity");
  print( Uri.parse(url));
  // http.get(url);
  // HttpRequest.getString(url);
  HT;
}*/
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

main(){
  MqttServerClient client =
  MqttServerClient.withPort('tcp://192.168.1.031', 'flutter_client', 1883);
  client.connect();
  client.subscribe("/EF3/KPI/CycleCount", MqttQos.atLeastOnce);
  client.updates.listen((event) { });
  // client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c ) {print(c);}
}


