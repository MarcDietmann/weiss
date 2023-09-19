import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weiss_app/2022/constants.dart';
import 'package:weiss_app/machine_detail_screen.dart';
import 'package:weiss_app/widgets/rounded_container.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 100,
                      ),
                      SizedBox(width:8,),
                      Text(
                        "Maschinenübersicht",
                        style: kHeadingStyle.copyWith(fontSize: 80),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TCMachineCard(
                      onDetailScreen: false,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RoundedContainer(
                    height: 300,
                    width: 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_box_outlined,
                          size: 100,
                        ),
                        Text(
                          "Neue Maschine hinzufügen",
                          style: kSubHeadingStyle.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
