import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as c;
import 'package:weiss_app/classes.dart';
import 'package:weiss_app/constants.dart';
import 'package:weiss_app/hybrid_provider.dart';
import 'package:weiss_app/url_input.dart';

class PlotPage extends StatefulWidget {
  @override
  _PlotPageState createState() => _PlotPageState();
}

class _PlotPageState extends State<PlotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStack(
        child: ListView(
          children: [
            ///cam0
            Container(
              color: kYellow,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("CAM 0", style: TextStyle(fontSize: 32),)),
              ),
            ),
            CustomBubblePlot_Cam(
              heading: "Axis 0",

              xMapper: (Cam data, _) => data.angleDegree!.round(),
              yMapper: (Cam data, _) => data.angleVelocity!.round()   ,
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.cam0!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Velocity"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
            ),

            ///cam1
            Container(
              color: kYellow,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("CAM 1", style: TextStyle(fontSize: 32),)),
              ),
            ),

            CustomBubblePlot_Cam(
              heading: "Axis 0",
              xMapper: (Cam data, _) => data.angleDegree!.round(),
              yMapper: (Cam data, _) => data.angleVelocity!.round()   ,
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.cam1!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Velocity"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
            ),

            ///corner0
            Container(
              color: kYellow,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Corner 0", style: TextStyle(fontSize: 32),)),
              ),
            ),


            CustomBubblePlot_Corner(
              heading: "Axis 0",
              xTitle: "angle 0 Degree",
              yTitle: "angle 0 Velocity",
              xMapper: (Corner data, _) => data.degreeData[0]!.round(),
              yMapper: (Corner data, _) => data.velocityData[0]!.round(),
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.corner0!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Velocity"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
            ),
            CustomBubblePlot_Corner(
              heading: "Axis 1",
              xTitle: "angle 1 Degree",
              yTitle: "angle 1 Velocity",
              xMapper: (Corner data, _) => data.degreeData[1]!.round(),
              yMapper: (Corner data, _) => data.velocityData[1]!.round(),
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.corner0!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
            ),
            CustomBubblePlot_Corner(
              heading: "Axis 2",
              xTitle: "angle 2 Degree",
              yTitle: "angle 2 Velocity",
              xMapper: (Corner data, _) => data.degreeData[2]!.round(),
              yMapper: (Corner data, _) => data.velocityData[2]!.round(),
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.corner0!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
            ),

            ///corner1
            ///
            Container(
              color: kYellow,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("CORNER 1", style: TextStyle(fontSize: 32),)),
              ),
            ),

            CustomBubblePlot_Corner(
              heading: "Axis 0",
              xTitle: "angle 0 Degree",
              yTitle: "angle 0 Velocity",
              xMapper: (Corner data, _) => data.degreeData[0]!.round(),
              yMapper: (Corner data, _) => data.velocityData[0]!.round(),
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.corner1!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Velocity"),
                minimum: 0,
                maximum: 360,
                interval: 90,
              ),
            ),
            CustomBubblePlot_Corner(
              heading: "Axis 1",
              xTitle: "angle 1 Degree",
              yTitle: "angle 1 Velocity",
              xMapper: (Corner data, _) => data.degreeData[1]!.round(),
              yMapper: (Corner data, _) => data.velocityData[1]!.round(),
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.corner1!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
            ),
            CustomBubblePlot_Corner(
              heading: "Axis 2",
              xTitle: "angle 2 Degree",
              yTitle: "angle 2 Velocity",
              xMapper: (Corner data, _) => data.degreeData[2]!.round(),
              yMapper: (Corner data, _) => data.velocityData[2]!.round(),
              dataSource: [
                Provider.of<HybridProvider>(context, listen: true).data!.corner1!
              ],
              xAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
              yAxis: c.NumericAxis(
                title: c.AxisTitle(text: "degree Position"),
                minimum: 0,
                maximum: 1000,
                interval: 100,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class CustomBubblePlot_Cam extends StatelessWidget {
  const CustomBubblePlot_Cam({
    Key? key,
    required this.heading,

    required this.dataSource,
    required this.xMapper,
    required this.yMapper,
    required this.xAxis,
    required this.yAxis,
  }) : super(key: key);
  final String heading;
  final List<Cam> dataSource;
  final int? Function(Cam, int) xMapper;
  final int? Function(Cam, int) yMapper;
  final c.NumericAxis xAxis;
  final c.NumericAxis yAxis;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 400,
        width: 400,
        child: c.SfCartesianChart(
          title: c.ChartTitle(text: heading),
          borderColor: Colors.black,
          borderWidth: 2,
          margin: EdgeInsets.all(24),
          primaryXAxis: xAxis,
          primaryYAxis: yAxis,
          series: <c.ChartSeries<Cam, int>>[
            c.BubbleSeries<Cam, int>(
              maximumRadius: 5,
              // dataLabelMapper: (_, __)=>"hello",
              dataSource: dataSource,
              sizeValueMapper: (_, __) => 0.01,
              xValueMapper: xMapper,
              yValueMapper: yMapper,
              animationDuration: 1000,
            ),
          ],
        ),
      ),
    );
  }
}
class CustomBubblePlot_Corner extends StatelessWidget {
  const CustomBubblePlot_Corner({
    Key? key,
    required this.heading,
    required this.xTitle,
    required this.yTitle,
    required this.dataSource,
    required this.xMapper,
    required this.yMapper,
    required this.xAxis,
    required this.yAxis,
  }) : super(key: key);
  final String heading;
  final String xTitle;
  final String yTitle;
  final List<Corner> dataSource;
  final int? Function(Corner, int) xMapper;
  final int? Function(Corner, int) yMapper;
  final c.NumericAxis xAxis;
  final c.NumericAxis yAxis;

  @override
  Widget build(BuildContext context) {
    return c.SfCartesianChart(
      title: c.ChartTitle(text: heading),
      borderColor: Colors.black,
      borderWidth: 2,
      margin: EdgeInsets.all(24),
      primaryXAxis: xAxis,
      primaryYAxis: yAxis,
      series: <c.ChartSeries<Corner, int>>[
        c.BubbleSeries<Corner, int>(
          dataSource: dataSource,
          sizeValueMapper: (_, __) => 0.01,
          xValueMapper: xMapper,
          yValueMapper: yMapper,
          animationDuration: 1000,
        ),
      ],
    );
  }
}

class PlotContainer extends StatelessWidget {
  const PlotContainer({
    Key? key,
    required this.xLabel,
    required this.yLabel,
    required this.points,
    required this.heading,
  }) : super(key: key);
  final String xLabel;
  final String yLabel;
  final List<Point> points;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(heading),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Provider.of<HybridProvider>(context, listen: true)
              .data!
              .corner0
              .toString()),
        ),
        /*Container(
          height: 200.0,
          width: 200,
          child: new Plot(
            centered: false,
            data: points,
            gridSize: new Offset(120, 120),
            style: new PlotStyle(
              axisStrokeWidth: 2.0,
              pointRadius: 3.0,
              outlineRadius: 1.0,
              primary: Colors.yellow,
              secondary: Colors.red,
              trace: true,
              traceStokeWidth: 3.0,
              traceColor: Colors.blueGrey,
              traceClose: true,
              showCoordinates: true,
              textStyle: new TextStyle(
                fontSize: 8.0,
                color: Colors.grey,
              ),
              axis: Colors.blueGrey[600],
              gridline: Colors.blueGrey[100],
            ),
            xTitle: xLabel,
            yTitle: yLabel,
            padding: const EdgeInsets.fromLTRB(40.0, 12.0, 12.0, 40.0),

    ),
        ),*/
      ],
    );
  }
}
