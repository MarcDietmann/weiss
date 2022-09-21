import 'package:http/http.dart';

class CyclicData {
  System? system;
  Cam? cam0;
  Cam? cam1;
  Corner? corner0;
  Corner? corner1;

  CyclicData({system, cam0, cam1, corner0, corner1});

  CyclicData.fromJson(Map<String, dynamic> json) {
    system = json['System'] != null ? System.fromJson(json['System']) : null;
    cam0 = json['Cam0'] != null ? Cam.fromJson(json['Cam0']) : null;
    cam1 = json['Cam1'] != null ? Cam.fromJson(json['Cam1']) : null;
    corner0 = json['Corner0'] != null ? Corner.fromJson(json['Corner0']) : null;
    corner1 = json['Corner1'] != null ? Corner.fromJson(json['Corner1']) : null;
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
  String? axis0Velocity;
  String toString() {
    return "{axis0Position: $axis0Position; axis0Velocity:$axis0Velocity}";
  }

  Cam({axis0Position, axis0Velocity});

  Cam.fromJson(Map<String, dynamic> json) {
    axis0Position = json['Axis0Position'];
    axis0Velocity = json['Axis0Velocity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Axis0Position'] = axis0Position;
    data['Axis0Velocity'] = axis0Velocity;
    return data;
  }
}

class Corner {
  String? axis0Position;
  String? axis0Velocity;
  String? axis1Position;
  String? axis1Velocity;
  String? axis2Position;
  String? axis2Velocity;
  String toString() {
    return "{axis0Position: $axis0Position; axis0Velocity:$axis0Velocity; axis1Position: $axis1Position; axis1Velocity:$axis1Velocity; axis2Position: $axis2Position; axis0Velocity:$axis0Velocity}";
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
