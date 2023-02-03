import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'glucosemeter_plugin_method_channel.dart';

abstract class GlucosemeterPluginPlatform extends PlatformInterface {
  /// Constructs a GlucosemeterPluginPlatform.
  GlucosemeterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static GlucosemeterPluginPlatform _instance = MethodChannelGlucosemeterPlugin();

  /// The default instance of [GlucosemeterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelGlucosemeterPlugin].
  static GlucosemeterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GlucosemeterPluginPlatform] when
  /// they register themselves.
  static set instance(GlucosemeterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> openBluetooth() {
    throw UnimplementedError('openBluetooth() has not been implemented.');
  }

  Future<void> closeBluetooth(){
    throw UnimplementedError('closeBluetooth() has not been implemented.');
  }

  Future<void> scanBluetooth(){
    throw UnimplementedError('scanBluetooth() has not been implemented.');
  }

  Future<void> stopScan(){
    throw UnimplementedError('stopScan() has not been implemented.');
  }

  Future<void> connectBluetooth(Object bluetoothDevice){
    throw UnimplementedError('connectBluetooth() has not been implemented.');
  }

  Future<void> automaticConnectBluetooth(){
    throw UnimplementedError('automaticConnectBluetooth() has not been implemented.');
  }

  Future<void> disconnectBluetooth(){
    throw UnimplementedError('disconnectBluetooth() has not been implemented.');
  }

  Future<String?> connectedDeviceName(){
    throw UnimplementedError('connectedDeviceName() has not been implemented.');
  }

  Future<String?> connectedBluetoothDeviceAddress(){
    throw UnimplementedError('connectedBluetoothDeviceAddress() has not been implemented.');
  }

  Future<void> connectedBluetoothDeviceRssi(){
    throw UnimplementedError('connectedBluetoothDeviceRssi() has not been implemented.');
  }

  Future<bool?> bluetoothState(){
    throw UnimplementedError('bluetoothState() has not been implemented.');
  }

  Future<void> attachBluetoothListener(){
    throw UnimplementedError('attachBluetoothListener() has not been implemented.');
  }

  Stream<String> get bluetoothStream {
    throw UnimplementedError('bluetoothStream() has not been implemented.');
  }
}
