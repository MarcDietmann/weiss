import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/2022/plot.dart';

// import 'chart_page.dart';
import 'hybrid_provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart' as charts;

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
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    Provider.of<HybridProvider>(context, listen: true).data ==
                            null
                        ? "Looking for device..."
                        : "Device found!"),
              ),
              Provider.of<HybridProvider>(context, listen: true).data != null
                  ? MainButton(
                      controller: controller,
                      icon: Icon(CupertinoIcons.graph_circle_fill),
                      label: 'Display graph',
                      onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlotPage(),
                              ),
                            ),
                          })
                  : MainButton(
                      controller: controller,
                      icon: Icon(CupertinoIcons.graph_circle_fill),
                      label: 'Display graph',
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: MyStack(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "You are not able to fetch the data. Please go back and try again!"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      },
                    ),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.search_circle_fill),
                  label: 'Find devices',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .getData(controller.text)),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.dot_radiowaves_left_right),
                  label: 'Retrieve live data',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .addLiveData(controller.text)),
              MainButton(
                  controller: controller,
                  icon: Icon(CupertinoIcons.stop_circle_fill),
                  label: 'Stop listening',
                  onPressed: () =>
                      Provider.of<HybridProvider>(context, listen: false)
                          .stopListening()),
            ],
          ),
          FuckGoBack(),
        ]),
      ),
    );
  }
}

class MyStack extends StatelessWidget {
  const MyStack({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          child,
          FuckGoBack(),
        ],
      ),
    );
  }
}

class FuckGoBack extends StatelessWidget {
  const FuckGoBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Opacity(
            opacity: 0.4,
            child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Icon(CupertinoIcons.xmark)),
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
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(40, 46, 49, 90),
            textStyle: TextStyle(
                fontWeight: FontWeight.bold)),
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
