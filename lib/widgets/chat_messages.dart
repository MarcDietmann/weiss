import 'package:flutter/material.dart';

import '../2022/constants.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String role;
  final String? functionName;
  final bool error;
  const ChatMessage({
    Key? key,
    required this.text,
    required this.role,
    this.error = false,
    this.functionName,
  }) : super(key: key);

  ChatMessage.fromMap(Map<String, dynamic> map, {super.key})
      : text = map["content"].toString(),
        role = map["role"].toString(),
        error = map["error"] ?? false,
        functionName = map["name"];

  @override
  Widget build(BuildContext context) {
    if (role == "system") return Container();
    if (role == "function")
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text("Function Call to ${functionName ?? "--"}: $text"),
      );

    bool _ownMessage;

    _ownMessage = role == "user";

    Widget child = Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _ownMessage ? kYellow : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: error ? Colors.red : null),
      ),
    );

    return Container(
        child: SizedBox(
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                _ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  text.length >= 50 ? Expanded(child: child) : child,
                ],
              ),
              SizedBox(
                child: Divider(),
              ),
            ],
          ),
        ));
  }
}
