
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/2022/constants.dart';
import 'package:weiss_app/utils/llm_wrapper.dart';
import 'package:weiss_app/widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double chatWidth = MediaQuery.of(context).size.width <= 600
        ? MediaQuery.of(context).size.width
        : min(MediaQuery.of(context).size.width * 0.5,
        MediaQuery.of(context).size.width);

    List<Map<String, dynamic>> messages = context.watch<LLMWrapper>().messages;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: chatWidth,
          child: Container(
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length + (context.read<LLMWrapper>().loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return Container(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return ChatMessage.fromMap(messages[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kYellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: textEditingController,
                      onEditingComplete: onEditingComplete,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kYellow.withOpacity(0.4), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black, width: 2.0),
                        ),
                      ),
                      // maxLines: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEditingComplete() async {
    if (textEditingController.text.isEmpty) return;
    if (context.read<LLMWrapper>().loading) return;
    context.read<LLMWrapper>().completeChat(newPromptText: textEditingController.text);
    textEditingController.clear();
  }
}