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
}
