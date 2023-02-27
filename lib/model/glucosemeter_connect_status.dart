class GlucosemeterConnectStatus {
  String? deviceName;
  bool? isConnected;

  GlucosemeterConnectStatus({this.deviceName, this.isConnected});

  GlucosemeterConnectStatus.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    isConnected = json['isConnected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceName'] = this.deviceName;
    data['isConnected'] = this.isConnected;
    return data;
  }
}
