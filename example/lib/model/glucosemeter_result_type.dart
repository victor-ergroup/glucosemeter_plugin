enum ResultType {
  searchStarted,
  searchStopped,
  onDeviceSpyListener,
  deviceBreak,
  onDeviceConnectSucceed,
  concentrationResultReceived,
  testPaperListened,
  onBleedResultListened,
  onDownTimeListened,
  errorTypeListener,
  memorySyncListener,
  deviceResultListener,
  bluetoothRssi,
  onDeviceConnectFailing
}

extension ParseToString on ResultType {
  String toShortString() {
    return toString().split('.').last;
  }
}