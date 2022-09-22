import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CyclicData {
  System? system;
  Cam? cam0;
  Cam? cam1;
  Corner? corner0;
  Corner? corner1;

  List<Corner> corners = [];
  List<Cam> cams = [];

  CyclicData({system, cam0, cam1, corner0, corner1});

  CyclicData.fromJson(Map<String, dynamic> json) {
    system = json['System'] != null ? System.fromJson(json['System']) : null;
    cam0 = json['Cam0'] != null ? Cam.fromJson(json['Cam0']) : null;
    cam1 = json['Cam1'] != null ? Cam.fromJson(json['Cam1']) : null;
    corner0 = json['Corner0'] != null ? Corner.fromJson(json['Corner0']) : null;
    corner1 = json['Corner1'] != null ? Corner.fromJson(json['Corner1']) : null;
    corners = [corner0!, corner1!];
    cams = [cam0!, cam1!];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (system != null) {
      data['System'] = system!.toJson();
    }
    if (cam0 != null) {
      data['Cam0'] = cam0!.toJson();
    }
    if (cam1 != null) {
      data['Cam1'] = cam1!.toJson();
    }
    if (corner0 != null) {
      data['Corner0'] = corner0!.toJson();
    }
    if (corner1 != null) {
      data['Corner1'] = corner1!.toJson();
    }
    return data;
  }

  String toString() {
    return "System: ${system.toString()}\nCam0: ${cam0.toString()}\nCam1: ${cam1.toString()}\nCorner0: ${corner0.toString()}\nCorner1: ${corner1.toString()}";
  }
}

class System {
  String? onlineTime;
  String? enabledTime;

  System({onlineTime, enabledTime});

  System.fromJson(Map<String, dynamic> json) {
    onlineTime = json['OnlineTime'];
    enabledTime = json['EnabledTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OnlineTime'] = onlineTime;
    data['EnabledTime'] = enabledTime;
    return data;
  }

  String toString() {
    return "{OnlineTime: $onlineTime; EnabledTime:$enabledTime}";
  }
}

class Cam {
  String? axis0Position;
  double? angleDegree;
  String? axis0Velocity;
  double? angleVelocity;
  String toString() {
    return "{axis0Position: $axis0Position; axis0Velocity:$axis0Velocity}";
  }

  Cam({axis0Position, axis0Velocity});

  Cam.fromJson(Map<String, dynamic> json) {
    axis0Position = json['Axis0Position'];
    axis0Velocity = json['Axis0Velocity'];
    angleDegree = int.parse(axis0Position!) / 1000;
    angleVelocity = int.parse(axis0Velocity!) / 10;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Axis0Position'] = axis0Position;
    data['Axis0Velocity'] = axis0Velocity;
    return data;
  }

  Point toPoint() {
    print(Point(angleDegree!.round(), angleVelocity!.round()));
    return Point(angleDegree!.round(), angleVelocity!.round());
  }
}

class Corner {
  String? axis0Position;
  String? axis0Velocity;
  String? axis1Position;
  String? axis1Velocity;
  String? axis2Position;
  String? axis2Velocity;

  double? angle0Degree;
  double? angle1Degree;
  double? angle2Degree;
  double? angle0Velocity;
  double? angle1Velocity;
  double? angle2Velocity;

  Color color_zero = Colors.yellow;
  Color color_one = Colors.blue;
  Color color_two = Colors.green;

  List<double?> degreeData = [];

  List<double?> velocityData = [];

  String toString() {
    return "{axis0Position: $axis0Position; axis0Velocity:$axis0Velocity; axis1Position: $axis1Position; axis1Velocity:$axis1Velocity; axis2Position: $axis2Position; axis0Velocity:$axis0Velocity}";
  }

  Point toPoint(axis) {
    switch (axis) {
      case 0:
        print(Point(angle0Degree!.round(), angle0Velocity!.round()));
        return Point(angle0Degree!.round(), angle0Velocity!.round());
      case 1:
        print(Point(angle1Degree!.round(), angle1Velocity!.round()));
        return Point(angle1Degree!.round(), angle1Velocity!.round());
      case 2:
        print(Point(angle2Degree!.round(), angle2Velocity!.round()));
        return Point(angle2Degree!.round(), angle2Velocity!.round());
      default:
        return Point(1, 1);
    }
  }

  Corner(
      {axis0Position,
      axis0Velocity,
      axis1Position,
      axis1Velocity,
      axis2Position,
      axis2Velocity});

  Corner.fromJson(Map<String, dynamic> json) {
    axis0Position = json['Axis0Position'];
    axis0Velocity = json['Axis0Velocity'];
    axis1Position = json['Axis1Position'];
    axis1Velocity = json['Axis1Velocity'];
    axis2Position = json['Axis2Position'];
    axis2Velocity = json['Axis2Velocity'];

    angle0Degree = int.parse(axis0Position!) / 1000;
    angle1Degree = int.parse(axis1Position!) / 1000;
    angle2Degree = int.parse(axis2Position!) / 1000;
    angle0Velocity = int.parse(axis0Velocity!) / 10;
    angle1Velocity = int.parse(axis1Velocity!) / 10;
    angle2Velocity = int.parse(axis2Velocity!) / 10;
    degreeData = [angle0Degree, angle1Degree, angle2Degree];
    velocityData = [angle0Velocity, angle1Velocity, angle2Velocity];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Axis0Position'] = axis0Position;
    data['Axis0Velocity'] = axis0Velocity;
    data['Axis1Position'] = axis1Position;
    data['Axis1Velocity'] = axis1Velocity;
    data['Axis2Position'] = axis2Position;
    data['Axis2Velocity'] = axis2Velocity;
    return data;
  }
}

class LiveData {
  int? index;
  CyclicData? value;
  LiveData({required int index, CyclicData? value}) {
    this.index = index;
    this.value = value;
  }
  String toString() {
    return "{index: ${index ?? "null"}\nvalue: ${value ?? "null"}}";
  }
}

class Plot {}
