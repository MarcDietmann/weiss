class CyclicData {
  System? system;
  Cam? cam0;
  Cam? cam1;
  Corner? corner0;
  Corner? corner1;

  CyclicData({this.system, this.cam0, this.cam1, this.corner0, this.corner1});

  CyclicData.fromJson(Map<String, dynamic> json) {
    system =
    json['System'] != null ? new System.fromJson(json['System']) : null;
    cam0 = json['Cam0'] != null ? new Cam.fromJson(json['Cam0']) : null;
    cam1 = json['Cam1'] != null ? new Cam.fromJson(json['Cam1']) : null;
    corner0 =
    json['Corner0'] != null ? new Corner.fromJson(json['Corner0']) : null;
    corner1 =
    json['Corner1'] != null ? new Corner.fromJson(json['Corner1']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.system != null) {
      data['System'] = this.system!.toJson();
    }
    if (this.cam0 != null) {
      data['Cam0'] = this.cam0!.toJson();
    }
    if (this.cam1 != null) {
      data['Cam1'] = this.cam1!.toJson();
    }
    if (this.corner0 != null) {
      data['Corner0'] = this.corner0!.toJson();
    }
    if (this.corner1 != null) {
      data['Corner1'] = this.corner1!.toJson();
    }
    return data;
  }
}

class System {
  String? onlineTime;
  String? enabledTime;

  System({this.onlineTime, this.enabledTime});

  System.fromJson(Map<String, dynamic> json) {
    onlineTime = json['OnlineTime'];
    enabledTime = json['EnabledTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OnlineTime'] = this.onlineTime;
    data['EnabledTime'] = this.enabledTime;
    return data;
  }


}

class Cam {
  String? axis0Position;
  String? axis0Velocity;

  Cam({this.axis0Position, this.axis0Velocity});

  Cam.fromJson(Map<String, dynamic> json) {
    axis0Position = json['Axis0Position'];
    axis0Velocity = json['Axis0Velocity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Axis0Position'] = this.axis0Position;
    data['Axis0Velocity'] = this.axis0Velocity;
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

  Corner(
      {this.axis0Position,
        this.axis0Velocity,
        this.axis1Position,
        this.axis1Velocity,
        this.axis2Position,
        this.axis2Velocity});

  Corner.fromJson(Map<String, dynamic> json) {
    axis0Position = json['Axis0Position'];
    axis0Velocity = json['Axis0Velocity'];
    axis1Position = json['Axis1Position'];
    axis1Velocity = json['Axis1Velocity'];
    axis2Position = json['Axis2Position'];
    axis2Velocity = json['Axis2Velocity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Axis0Position'] = this.axis0Position;
    data['Axis0Velocity'] = this.axis0Velocity;
    data['Axis1Position'] = this.axis1Position;
    data['Axis1Velocity'] = this.axis1Velocity;
    data['Axis2Position'] = this.axis2Position;
    data['Axis2Velocity'] = this.axis2Velocity;
    return data;
  }
}