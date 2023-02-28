
import 'glucosemeter_plugin_platform_interface.dart';
import 'model/glucosemeter_result.dart';

class GlucosemeterPlugin {
  Future<String?> getPlatformVersion() {
    return GlucosemeterPluginPlatform.instance.getPlatformVersion();
  }

  /// Turn on Bluetooth (Not working)
  Future<void> openBluetooth(){
    return GlucosemeterPluginPlatform.instance.openBluetooth();
  }

  /// Turn off Bluetooth (Not working)
  Future<void> closeBluetooth(){
    return GlucosemeterPluginPlatform.instance.closeBluetooth();
  }

  /// Scan for bluetooth devices and automatically connect it
  Future<void> scanBluetooth(){
    return GlucosemeterPluginPlatform.instance.scanBluetooth();
  }

  /// Stop the bluetooth scanning
  Future<void> stopScan(){
    return GlucosemeterPluginPlatform.instance.stopScan();
  }

  /// Automatically connect to bluetooth device
  Future<void> automaticConnectBluetooth(){
    return GlucosemeterPluginPlatform.instance.automaticConnectBluetooth();
  }

  /// Disconnect from connected bluetooth device
  Future<void> disconnectBluetooth(){
    return GlucosemeterPluginPlatform.instance.disconnectBluetooth();
  }

  // Connect bluetooth device
  // Future<void> connectBluetooth(Object bluetoothDevice){
  //   return GlucosemeterPluginPlatform.instance.connectBluetooth(bluetoothDevice);
  // }

  /// Show the connected device name
  Future<String?> connectedDeviceName(){
    return GlucosemeterPluginPlatform.instance.connectedDeviceName();
  }

  /// Shows the connected device Received Signal Strength Indicator (RSSI)
  Future<void> connectedBluetoothDeviceRssi(){
    return GlucosemeterPluginPlatform.instance.connectedBluetoothDeviceRssi();
  }

  /// Shows the connected bluetooth device MAC address
  Future<String?> connectedBluetoothDeviceAddress(){
    return GlucosemeterPluginPlatform.instance.connectedBluetoothDeviceAddress();
  }

  /// Shows the current bluetooth state
  /// Returns `true` if the device's bluetooth is on
  Future<bool?> bluetoothState(){
    return GlucosemeterPluginPlatform.instance.bluetoothState();
  }

  /// Stream data from bluetooth device. ie: BloodGlucoseData.
  /// Use `GlucosemeterResult` model to parse the result.
  /// Available type functions:
  /// `searchStarted`
  /// `searchStopped`
  /// `onDeviceSpyListener`
  /// ```json
  /// data {
  ///   "deviceName" : "<device_name>" // nullable
  ///   "isConnected" : true,
  /// }
  /// ```
  /// `deviceBreak`
  /// `deviceConnectSucceed`
  /// `concentrationResultReceived`
  ///  ```json
  ///  data { // BloodGlucoseData
  ///    "concentration" : "4.14",
  ///    "timestamp" : "1677458329",
  ///  }
  ///  ```
  /// `testPaperListened`
  /// `onBleedResultListened`
  /// `onDownTimeListened`
  /// ```json
  /// data {
  ///   // timer
  /// }
  /// ```
  /// `errorTypeListener`
  /// ```json
  /// data {
  ///   // error type
  /// }
  /// ```
  /// `memorySyncListener`
  /// ```json
  /// data {
  ///   // List of BloodGlucoseData
  /// }
  /// ```
  /// `deviceResultListener`
  /// ```json
  /// data {
  ///   "model" : "<device_model>",
  ///   "deviceProcedure" : "<device_procedure>",
  ///   "deviceVersion" : "<device_version>"
  /// }
  /// ```
  /// `bluetoothRssi`
  /// ```json
  /// data {
  ///   // RSSI
  /// }
  /// ```
  /// `onDeviceConnectFailing`
  /// ```json
  /// data {
  ///   // failure code
  /// }
  /// ```
  Stream<GlucosemeterResult> getBluetoothStream(){
    return GlucosemeterPluginPlatform.instance.bluetoothStream;
  }
}
