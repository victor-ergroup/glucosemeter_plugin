class BloodGlucoseData {
  String? concentration;
  String? timestamp;

  BloodGlucoseData({this.concentration, this.timestamp});

  BloodGlucoseData.fromJson(Map<String, dynamic> json) {
    concentration = json['concentration'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concentration'] = this.concentration;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
