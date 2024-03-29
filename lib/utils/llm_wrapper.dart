import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weiss_app/utils/diagnostics_provider.dart';

class LLMWrapper extends ChangeNotifier {
  bool loading = false;
  static const String url = 'https://api.openai.com/v1/chat/completions';
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Bearer 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'
  };
  List<String> token = [
    "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",
    "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",
    "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"
  ];
  int currentToken = 0;
  List<Map<String, dynamic>> messages = [
    {
      "role": "system",
      "content":
          "Du bist ein Hilfechatbot um unseren Kunden bei Problemen an Produktionsmachinen zu helfen. Gib knappe Handlungsempfehlungen. "
              "Wenn Daten in einen kritischen Bereich kommen kann es zu schäden an der Maschine kommen und eine schneller Reperatur ist von nöten."
              " Bounds cmin bedeuted kritisches min, cmax kritisches max:${DiagnosticsProvider.bounds.toString()}. "
              "Wenn die Drehzeit zu schnell ist, ist die Maschine wahrscheinlich falsch eingestellt. Wenn die Stromstärke zu hoch ist kann das auf eine blockierte Maschine hindeuten."
              " Wenn die Vibration zu hoch ist, kann das auf einen Defekt hindeuten. Wenn die Vibration zu hoch ist, kann das an einem kapputen Kugellager liegen "
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
    },
    // {
    //   "name": "get_bounds",
    //   "description":
    //       "The system has specification lower and upper bounds for each of the available data. Between min and max the value is good. cmin and cmax are critical thresholds.",
    //   "parameters": {
    //     "properties": {
    //       "scope": {
    //         "type": "string",
    //         "description": "request either all or none of the available data"
    //       },
    //     },
    //     "required": ["scope"]
    //   },
    // }
  ];

  String _getCurrentToken() {
    return token[currentToken];
  }

  void changeToken() {
    currentToken = (currentToken + 1) % token.length;
    headers["Authorization"] = "Bearer ${_getCurrentToken()}";
  }

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
      "temperature": 0,
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
    if (name == "get_current_status") {
      return "Temperatur: 42.1 Grad. Durchschnittliche Vibration in der letzer Minute 53.92. Stromstärke des Motors ist zu hoch mit 0.66 Ampere. Die Dauer der Drehung ist zu hoch mit nur 0.25ms";
    }
    if (name == "get_bounds") {
      return DiagnosticsProvider.bounds.toString();
    }
    return "Function $name not implemented";
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
