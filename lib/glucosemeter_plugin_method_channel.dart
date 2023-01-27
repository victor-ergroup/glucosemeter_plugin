import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'glucosemeter_plugin_platform_interface.dart';

/// An implementation of [GlucosemeterPluginPlatform] that uses method channels.
class MethodChannelGlucosemeterPlugin extends GlucosemeterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('glucosemeter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
