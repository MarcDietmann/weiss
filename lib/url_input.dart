import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes.dart';
import 'ls_hybrid.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;


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
    late Timer timer;
    void initTimer() {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        Provider.of<HybridProvider>(context, listen: false)
            .getData(controller.text);
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Connect to maschine')),
        body: Center(
          child: Column(

            children: [
              Container(
                height: 400,
                child: charts.SfCartesianChart(
                  series: charts.LineSeries<LiveData, int>(
                    dataSource: chartData,
                    color: Colors.red,
                    xValueMapper: (LiveData l, _)=>l.index,
                    yValueMapper: (LiveData l, _)=> num.parse(l.value!.corner1!.axis0Position!),
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                      Provider.of<HybridProvider>(context, listen: false)
                          .getData(controller.text);
                    });
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
                        Text('start listening'),
                        SizedBox(
                          width: 50,
                        ),
                      ]),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    timer.cancel();
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
                        Text('stop listening'),
                        SizedBox(
                          width: 50,
                        ),
                      ]),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class LiveData {
  int? index;
  CyclicData? value;
}
