import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weiss_app/machine_provider.dart';
import 'package:weiss_app/overview_screen.dart';
import 'package:weiss_app/utils/diagnostics_provider.dart';
import 'package:weiss_app/utils/llm_wrapper.dart';
import 'package:weiss_app/utils/mqtt_provider.dart';

import 'machine_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) => MQTTProvider()),
      ChangeNotifierProvider(create: (_) => LLMWrapper()),
      ChangeNotifierProvider(create: (_) => MachineData()),
      ChangeNotifierProxyProvider<MQTTProvider,DiagnosticsProvider>(
          create: (_) => DiagnosticsProvider(),
          update: (_, mqttProvider, diagnosticsProvider) {
            if(diagnosticsProvider==null)return DiagnosticsProvider();
            diagnosticsProvider.mqttProvider = mqttProvider;
            return diagnosticsProvider;
          })
    ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          useMaterial3: true,
        ),
        home: LoadingScreen(),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<MQTTProvider>(context, listen: false).init();
    Provider.of<DiagnosticsProvider>(context, listen: false).init();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? OverviewScreen()
        : Scaffold(
            body: Container(
              child: Text("Loading"),
            ),
          );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MQTTProvider>(context, listen: false).subscribeToTopic(
        "Wallduern/Hackathon/TC150T/DeviceProperties/Temperature_processed",
        (msg) {
      print(MQTTProvider.getPayload(msg));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text('', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
