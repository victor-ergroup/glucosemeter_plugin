
import 'glucosemeter_plugin_platform_interface.dart';

class GlucosemeterPlugin {
  Future<String?> getPlatformVersion() {
    return GlucosemeterPluginPlatform.instance.getPlatformVersion();
  }

  Future<void> initGlucoseBluetoothUtil(){
    return GlucosemeterPluginPlatform.instance.initGlucoseBluetoothUtil();
  }

  Future<void> openBluetooth(){
    return GlucosemeterPluginPlatform.instance.openBluetooth();
  }

  Future<void> closeBluetooth(){
    return GlucosemeterPluginPlatform.instance.closeBluetooth();
  }

  Future<void> scanBluetooth(){
    return GlucosemeterPluginPlatform.instance.scanBluetooth();
  }

  Future<void> stopScan(){
    return GlucosemeterPluginPlatform.instance.stopScan();
  }

  Future<void> connectBluetooth(){
    return GlucosemeterPluginPlatform.instance.connectBluetooth();
  }

  Future<String?> connectedDeviceName(){
    return GlucosemeterPluginPlatform.instance.connectedDeviceName();
  }

  Future<void> connectedBluetoothDeviceRssi(){
    return GlucosemeterPluginPlatform.instance.connectedBluetoothDeviceRssi();
  }

  Future<String?> connectedBluetoothDeviceAddress(){
    return GlucosemeterPluginPlatform.instance.connectedBluetoothDeviceAddress();
  }

  Future<bool?> bluetoothState(){
    return GlucosemeterPluginPlatform.instance.bluetoothState();
  }

  Future<void> attachBluetoothListener(){
    return GlucosemeterPluginPlatform.instance.attachBluetoothListener();
  }
}
