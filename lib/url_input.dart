import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/plot.dart';
import 'chart_page.dart';
import 'hybrid_provider.dart';
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
/*    late Timer timer;
    void initTimer() {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        Provider.of<HybridProvider>(context, listen: false)
            .getData(controller.text);
      });
    }*/

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Connect to maschine')),
        body: Center(
          child: Column(
            children: [
              /*Container(
                height: 400,
                child: charts.SfCartesianChart(
                  series: charts.LineSeries<LiveData, int>(
                    dataSource: Provider.of<HybridProvider>(context,listen: true).chartData,
                    color: Colors.red,
                    xValueMapper: (LiveData l, _)=>l.index,
                    yValueMapper: (LiveData l, _)=> num.parse(l.value!.corner1!.axis0Position!),
                  ),
                ),
              ),*/
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
              MainButton(
                controller: controller,
                icon: Icon(CupertinoIcons.graph_circle_fill),
                label: 'show Graph',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlotPage(),
                  ),
                ),
              ),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.search_circle_fill),
                  label: 'search device',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .getData(controller.text)),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.dot_radiowaves_left_right),
                  label: 'create Live Data',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .addLiveData(controller.text)),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.play_circle_fill),
                  label: 'start listening',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .startListening()),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.stop_circle_fill),
                  label: 'stop listening',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .stopListening()),
            ],
          ),
        ),
      ),
    );
  }
}

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    this.controller,
    required this.label,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final TextEditingController? controller;
  final String label;
  final Callback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
            ),
            icon,
            SizedBox(
              width: 50,
            ),
            Text(label),
            SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );
  }
}

