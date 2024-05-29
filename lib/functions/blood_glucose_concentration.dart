class BloodGlucoseConcentration {
  String concentration;
  String timestamp;

  BloodGlucoseConcentration(this.concentration, this.timestamp);

  @override
  String toString() {
    return "{ concentration: ${concentration}, timestamp: ${timestamp} }";
  }
}