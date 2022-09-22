import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weiss_app/MQTT.dart';
import 'package:weiss_app/url_input.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStack(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainButton(
                label: "LSHybrid",
                onPressed: () {
                  print("object");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UrlInputPage(),
                    ),
                  );
                },
                icon: Icon(CupertinoIcons.arrow_swap)),
            MainButton(
                label: "EF3",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MQTT(),
                    ),
                  );
                  //
                },
                icon: Icon(CupertinoIcons.arrow_2_circlepath_circle_fill)),
            MainButton(
                label: "WAS2",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: MyStack(
                          child: Center(
                            child: Text(
                                "UPS. Das ist keine Schleichwerbung, hier feht noch was."),
                          ),
                        ),
                      ),
                    ),
                  );
                  //
                },
                icon: Icon(CupertinoIcons.alt)),
          ],
        ),
      ),
    );
  }
}

