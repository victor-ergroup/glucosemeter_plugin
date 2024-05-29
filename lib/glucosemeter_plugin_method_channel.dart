import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'glucosemeter_plugin_platform_interface.dart';
import 'model/glucosemeter_result.dart';

/// An implementation of [GlucosemeterPluginPlatform] that uses method channels.
class MethodChannelGlucosemeterPlugin extends GlucosemeterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('glucosemeter_plugin');

  static const EventChannel eventChannel = EventChannel('glucosemeter_plugin_event');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> openBluetooth() async {
    return await methodChannel.invokeMethod<void>('openBluetooth');
  }

  @override
  Future<void> closeBluetooth() async {
    return await methodChannel.invokeMethod<void>('closeBluetooth');
  }

  @override
  Future<void> scanBluetooth() async {
    return await methodChannel.invokeMethod<void>('scanBluetooth');
  }

  @override
  Future<void> stopScan() async {
    return await methodChannel.invokeMethod<void>('stopScan');
  }

  @override
  Future<void> connectBluetooth(Object bluetoothDevice) async {
    Map<String, dynamic> argsMap = {
      'bluetoothDevice' : bluetoothDevice.toString()
    };
    return await methodChannel.invokeMethod<void>('connectBluetooth', argsMap);
  }

  @override
  Future<String?> connectedDeviceName() async {
    return await methodChannel.invokeMethod<String>('connectedDeviceName');
  }

  @override
  Future<void> automaticConnectBluetooth() async {
    return await methodChannel.invokeMethod<void>('automaticConnectBluetooth');
  }

  @override
  Future<String?> connectedBluetoothDeviceAddress() async {
    return await methodChannel.invokeMethod<String>('connectedBluetoothDeviceAddress');
  }

  @override
  Future<void> connectedBluetoothDeviceRssi() async {
    return await methodChannel.invokeMethod<void>('connectedBluetoothDeviceRssi');
  }

  @override
  Future<void> disconnectBluetooth() async {
    return await methodChannel.invokeMethod<void>('disconnectBluetooth');
  }

  @override
  Future<bool?> bluetoothState() async {
    return await methodChannel.invokeMethod<bool>('bluetoothState');
  }

  @override
  Stream<GlucosemeterResult> get bluetoothStream {
    return eventChannel.receiveBroadcastStream().cast().asyncMap(
      (event) {
        print(event);
        return GlucosemeterResult.fromJson(jsonDecode(event));
      }
    );
  }
}
