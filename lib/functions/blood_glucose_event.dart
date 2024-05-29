class BloodGlucoseEvent {
  static const RESULT_TYPE = "RESULT";
  static const EVENT_TYPE = "EVENT";
  static const ERROR_TYPE = "ERROR";
  static const OTHER_TYPE = "OTHER";

  String type;
  String data;

  BloodGlucoseEvent(this.type, this.data);
}