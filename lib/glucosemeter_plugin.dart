
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

  Future<bool?> bluetoothState(){
    return GlucosemeterPluginPlatform.instance.bluetoothState();
  }
}
