import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/classes.dart';

import 'ls_hybrid.dart';

class UrlInputPage extends StatefulWidget {
  const UrlInputPage({Key? key}) : super(key: key);

  @override
  State<UrlInputPage> createState() => _UrlInputPageState();
}

class _UrlInputPageState extends State<UrlInputPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = "http://192.168.1.150/Hackathon2022/LSHybridJSON.asp";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Connect to maschine')),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(Provider.of<HybridProvider>(context, listen: true)
                    .data
                    .toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await Provider.of<HybridProvider>(context, listen: false)
                        .getData(controller.text);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          width: 50,
                        ),
                        Icon(CupertinoIcons.search),
                        SizedBox(
                          width: 50,
                        ),
                        Text('Gerät suchen'),
                        SizedBox(
                          width: 50,
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
