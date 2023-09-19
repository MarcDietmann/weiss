import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LLMWrapper extends ChangeNotifier {
  bool loading = false;
  static const String url = 'https://api.openai.com/v1/chat/completions';
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Bearer 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'
  };

  List<Map<String, dynamic>> messages = [
    {
      "role": "system",
      "content":
          "Du bist ein Hilfechatbot um unseren Kunden bei Problemen an Produktionsmachinen zu helfen. Wenn Daten in einen kritischen Bereich kommen kann es zu schäden an der Maschine kommen und eine schneller Reperatur ist von nöten. Kritische bereiche: Temperatur > 40 Grad; Vibration > 10; Druck > 1000; Drehzahl > 1000; Strom > 1000; Spannung > 12 Volt; "
    },
  ];

  List<Map<String, dynamic>> functions = [
    {
      "name": "get_current_status",
      "description": "Get the current status of the system",
      "parameters": {
        "type": "object",
        "properties": {
          "scope": {
            "type": "string",
            "description": "request either all or none of the available data"
          },

        },
        "required": ["scope"]
      }
    },{
      "name": "call_service",
      "description": "If the system is in a critical state and the first solution does not fix it, call the service",
      "parameters": {
        "type": "object",
        "properties": {
          "person": {
            "type": "string",
            "description": "request either all or none of the available data"
          },

        },
        "required": ["scope"]
      }
    }
  ];

  void completeChat({String? newPromptText}) async {
    if (newPromptText != null) {
      String userMessageId =
          addMessage({"role": "user", "content": newPromptText.trim()});
    }
    loading = true;
    notifyListeners();

    print("Messages: $messages");
    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "model": "gpt-4",
      "messages": getMessagesForTransfer(),
      "functions": functions,
      "temperature": 0.2,
      "top_p": 1,
      "n": 1,
      "stream": true,
      "max_tokens": 2500,
      "presence_penalty": 0,
      "frequency_penalty": 0
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String id = createNewMessage("assistant");
    notifyListeners();
    if (response.statusCode == 200) {
      response.stream.listen((value) => parseStreamResponse(value, id));
    } else {
      await handleErrorMessage(response, id);
    }
    loading = false;
    notifyListeners();
  }

  void parseStreamResponse(value, String messageId) {
    String utfDecoded = utf8.decode(value);
    // print("UTF Decoded: $utfDecoded");
    // try {
    List utfRemovedData = utfDecoded.split("\n");
    for (String dataSnippet in utfRemovedData) {
      if (dataSnippet.contains("data:")) {
        if (dataSnippet.contains("[DONE]")) {
          // print("Done: $utfRemovedData");
          var tmp = loading;
          loading = false;
          if (tmp != loading) {
            notifyListeners();
          }
          continue;
        }

        var data = jsonDecode(dataSnippet.replaceAll("data: ", ""));
        // print("Data: $data");
        appendToMessage(
            messageId, "content", data["choices"][0]["delta"]["content"] ?? "");

        if (data["choices"][0]["delta"]["function_call"]?["arguments"] !=
            null) {
          appendToMessage(messageId, "function_call_arguments",
              (data["choices"][0]["delta"]["function_call"]?["arguments"]));
        }

        if (data["choices"][0]["delta"]["function_call"]?["name"] != null) {
          appendToMessage(messageId, "function_call_name",
              (data["choices"][0]["delta"]["function_call"]?["name"]));
        }
        var finischReason = data["choices"][0]["finish_reason"];
        if (finischReason != null) {
          print("Finish Reason: $finischReason");
        }
        if (data["choices"][0]["finish_reason"] == "function_call") {
          print(
              "Function Call: ${getMessage(messageId)?["function_call_name"]}");
          print(
              "Function Call: ${getMessage(messageId)?["function_call_arguments"]}");
          promptFunctionCall(messageId);
        }
      }
    }
    // } catch (e) {
    //   print("Decoding Error: $e");
    // }
  }

  Future<void> promptFunctionCall(String messageId) async {
    Map? message = getMessage(messageId);
    if (message == null) {
      print("Message not found: $messageId");
      return;
    }
    String name = message["function_call_name"];
    Map? arguments = jsonDecode(message["function_call_arguments"]);

    String prompt = "Call function $name with arguments $arguments";
    String response = await callFunction(name, arguments);

    changeMessage(messageId, "role", "function");
    changeMessage(messageId, "name", name);
    changeMessage(messageId, "content", response);
    completeChat();
  }

  Future<String> callFunction(String name, Map? arguments) async {
    await Future.delayed(Duration(seconds: 1));
    return "Temperatur: 42 Grad. Vibration in letzer Minute 64. Stromspannung des Motors 13.4 Volt";
  }

  Future<void> handleErrorMessage(
      http.StreamedResponse response, String messageId) async {
    String errorMessage = "";
    try {
      errorMessage =
          jsonDecode(await response.stream.bytesToString())["error"]["message"];
    } catch (e) {
      //ignore
    }
    changeMessage(messageId, "content",
        "Error ${response.statusCode}: ${response.reasonPhrase}: $errorMessage");
    changeMessage(messageId, "error", true);
  }

  String createNewMessage(String role) {
    Map<String, dynamic> message = {"role": "$role", "content": ""};
    return addMessage(message);
  }

  String addMessage(Map<String, dynamic> message) {
    String id = getRandomString(10);
    print("Message ID: $id");
    message["id"] = id;
    messages.add(message);
    notifyListeners();
    return id;
  }

  void appendToMessage(String id, String field, var value) {
    Map? message = getMessage(id);
    if (message == null) {
      print("Message not found: $id $field $value");
      return;
    }
    if (value == null) {
      print("Value is null: $id $field $value");
      return;
    }
    changeMessage(id, field, (message[field] ?? "") + value.toString());
  }

  void changeMessage(String id, String field, var value) {
    Map? message = getMessage(id);
    if (message == null) {
      print("Message not found: $id $field $value");
      return;
    }
    message[field] = value;
    notifyListeners();
  }

  Map? getMessage(String id) {
    return messages.where((element) => element["id"] == id).first;
  }

  List<Map<String, dynamic>> getMessagesForTransfer() {
    List<Map<String, dynamic>> messagesForTransfer = [];
    for (Map message in messages) {
      Map<String, dynamic> _tmp = {
        "role": message["role"],
        "content": message["content"]
      };
      if (message["role"] == "function") {
        _tmp["name"] = message["name"];
      }
      messagesForTransfer.add(_tmp);
    }
    return messagesForTransfer;
  }

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
