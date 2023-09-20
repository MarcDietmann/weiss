
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/2022/constants.dart';
import 'package:weiss_app/utils/llm_wrapper.dart';
import 'package:weiss_app/widgets/chat_messages.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isFirstRequest = true;
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
      body: Row(
        children: [
          Spacer(),
          Center(
            child: SizedBox(
              width: chatWidth,
              child: Container(
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

                    !isFirstRequest?SizedBox(): Text("Vorschläge:",style: kSubHeadingStyle,),
                    !isFirstRequest?SizedBox(): ChatSuggestion(suggestionText: "Erkläre mir was mit meiner Maschine los ist.",onTap: onTap,),
                    !isFirstRequest?SizedBox(): ChatSuggestion(suggestionText: "Was müsste ich machen, um die Maschine zu reparieren.",onTap: onTap,),
                    !isFirstRequest?SizedBox(): ChatSuggestion(suggestionText: "Was ist passiert?",onTap: onTap,),
                    SizedBox(
                      height: 8,
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
                                  color: Colors.black, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black, width: 2.0),
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
          Expanded(
            child: Column(children: [
              Spacer(),
              GestureDetector(
                onTap: (){
                  context.read<LLMWrapper>().changeToken();
                }
                ,
                child: Text("Change Token",style: kSubHeadingStyle.copyWith(color: Colors.grey),),
              )
            ],),
          ),
        ],
      ),
    );

  }
  void onTap(String suggestionText){
    textEditingController.text = suggestionText;
    onEditingComplete();
  }

  void onEditingComplete() async {
    if (textEditingController.text.isEmpty) return;
    if (context.read<LLMWrapper>().loading) return;
    setState(() {
      isFirstRequest = false;
    });
    context.read<LLMWrapper>().completeChat(newPromptText: textEditingController.text);
    textEditingController.clear();
  }
}

class ChatSuggestion extends StatelessWidget {
  final String suggestionText;
  final Function(String) onTap;
  const ChatSuggestion({
    super.key, required this.suggestionText, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: ()=> onTap(suggestionText),
        child: Container(
          decoration: BoxDecoration(
            color: kYellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: kYellow,width: 2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(suggestionText,style: kTextStyle,),
          ),
        ),
      ),
    );
  }
}