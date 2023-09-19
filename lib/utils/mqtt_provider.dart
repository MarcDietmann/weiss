import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:typed_data/typed_buffers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTProvider extends ChangeNotifier {
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttStreamSub;
  Map<String, MqttReceivedMessage<MqttMessage?>> lastMessages = {};
  bool isConnected = false;
  Timer? mqttTopicRequestTimer;
  Duration mqttTopicRequestInterval = Duration(seconds: 10);
  Map<String, Function(MqttReceivedMessage<MqttMessage?>)> subscribedTopics =
  {}; //This map stores all subscribed topics and the callback that should be executed on message receive

  final client = MqttServerClient.withPort(
      '10.1.70.4', 'flutter_client', 1883);

  void init() async {
    setOnConnectionChangeCallbacks();
    await startConnection();
    ensureConOnConChange();
    setTimerForMqttTopicRequests();
  }

  void ensureConOnConChange() {
    Connectivity().onConnectivityChanged.listen((event) {
      disconnect();
      isConnected = false;
      notifyListeners();
      startConnection();
    });
  }

  Future<bool> startConnection() async {
    try {
      client.secure = false;
      client.autoReconnect = true;
      MqttClientConnectionStatus? status =
      await client.connect("julian", "NRirEQ7o");
      log("Mqttstatus $status");
      return status?.state == MqttConnectionState.connected;
    } catch (e) {
      log("Error in MQTT connect: $e");
      return false;
    }

  }

  void setTimerForMqttTopicRequests() {
    if (mqttTopicRequestTimer?.isActive == true) return;
    mqttTopicRequestTimer = Timer.periodic(mqttTopicRequestInterval, (timer) {
      requestSubscribedTopics();
    });
  }

  void requestSubscribedTopics() {
    if (!isConnected) return;
    for (String topic in subscribedTopics.keys) {
      requestTopic(topic);
    }
  }

  void requestTopic(String topic) {
    publishMessage(topic + "/request", true, plain: true);
  }

  void unrequestTopic(String topic) {
    publishMessage(topic + "/request", true, plain: false);
  }

  void setOnConnectionChangeCallbacks() {
    client.onConnected = () async {
      var tmp = isConnected;
      isConnected = true;
      if (tmp != isConnected) notifyListeners();
      for (String topic in subscribedTopics.keys) {
        requestTopic(topic);
        _mqttSubscribe(topic);
      }
      if (mqttStreamSub != null) {
        await mqttStreamSub!.cancel();
      }
      mqttStreamSub = client.updates!.listen((c) {
        var curMes = c.last;
        if (subscribedTopics.containsKey(curMes.topic)) {
          lastMessages[curMes.topic] = curMes;
          var callback = subscribedTopics[curMes.topic];
          if (callback != null) callback(curMes);
        }
      });
    };
    client.onDisconnected = () {
      print("disconnected");
      var tmp = isConnected;
      isConnected = false;
      if (tmp != isConnected) notifyListeners();
    };
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribeToTopic(String topic,
      Function(MqttReceivedMessage<MqttMessage?>)? onMessageCallback) async {
    if (!subscribedTopics.containsKey(topic)) {
      print("mqtt subscribe: $topic");
      requestTopic(topic);
      _mqttSubscribe(topic);
    } else {
      print("already subscribed to: $topic");
      if (lastMessages[topic] != null && onMessageCallback != null) {
        onMessageCallback(lastMessages[topic]!);
      }
    }
    subscribedTopics[topic] = onMessageCallback ?? standardMessageCallback;
  }

  void _mqttSubscribe(String topic) {
    try {
      if (client.connectionStatus?.state != MqttConnectionState.connected)
        return;
      client.subscribe(topic, MqttQos.atLeastOnce);
    } catch (e) {
      print("Error during mqtt subscribe: $e");
    }
  }

  void unsubscribeFromTopic(String topic) async {
    print("mqtt unsubscribe: " + topic);
    if (isConnected &&
        // ignore: invalid_use_of_protected_member
        client.subscriptionsManager?.subscriptions.keys.contains(topic) ==
            true) {
      _mqttUnsubscribe(topic);
    }
    unrequestTopic(topic);
    subscribedTopics.remove(topic);
  }

  void _mqttUnsubscribe(String topic) {
    try {
      client.unsubscribe(topic);
    } catch (e) {
      print("Error during mqtt unsubscribe: $e");
    }
  }

  void standardMessageCallback(MqttReceivedMessage<MqttMessage?> mes) {
    final topic = mes.topic;
    final recMess = mes.payload as MqttPublishMessage;
    final payload =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
    print("Message($topic}): $payload");
  }

  void publishMessage(String topic, Object data,
      {bool? plain = false, bool stringifyData = false}) {
    String payload = "";
    if (plain == true) {
      payload = data.toString();
    } else {
      Map transferMap = {"data": stringifyData ? data.toString() : data};
      payload = jsonEncode(transferMap);
    }
    var dataBuffer = MQTTProvider.convertToUint8Buffer(payload);
    if (client.connectionStatus?.state != MqttConnectionState.connected) return;
    client.publishMessage(topic, MqttQos.atLeastOnce, dataBuffer);
  }

  //This method can also be used for a topic on which you already subscribed
  Future<void> listenForNextMessage(String topic,
      Function(MqttReceivedMessage<MqttMessage?>?) onReceivedCallback,
      {bool latching = false}) async {
    var prefunc = subscribedTopics[topic];
    bool alreadySubscribed = subscribedTopics.containsKey(topic);
    if (alreadySubscribed) {
      print("already subscribed to this topic: " + topic);
    }
    int received = 0;
    subscribeToTopic(topic, (mes) {
      if (alreadySubscribed) prefunc!(mes);
      received++;
      if (latching && received < 2) return;
      onReceivedCallback(mes);
      if (alreadySubscribed) {
        subscribeToTopic(topic, prefunc);
      } else {
        unsubscribeFromTopic(topic);
      }
    });
  }

  static Uint8Buffer convertToUint8Buffer(String s) {
    var outputAsUint8List = Uint8List.fromList(s.codeUnits);
    Uint8Buffer dataBuffer = Uint8Buffer();
    dataBuffer.addAll(outputAsUint8List);
    return dataBuffer;
  }

  static String getPayload(MqttReceivedMessage<MqttMessage?> mes) {
    final recMess = mes.payload as MqttPublishMessage;
    final payload =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
    return payload;
  }

  @override
  void dispose() {
    super.dispose();
    mqttTopicRequestTimer?.cancel();
  }
}
