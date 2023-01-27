
import 'glucosemeter_plugin_platform_interface.dart';

class GlucosemeterPlugin {
  Future<String?> getPlatformVersion() {
    return GlucosemeterPluginPlatform.instance.getPlatformVersion();
  }
}
