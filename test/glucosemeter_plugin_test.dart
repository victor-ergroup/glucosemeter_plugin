import 'package:flutter_test/flutter_test.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin_platform_interface.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGlucosemeterPluginPlatform
    with MockPlatformInterfaceMixin
    implements GlucosemeterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GlucosemeterPluginPlatform initialPlatform = GlucosemeterPluginPlatform.instance;

  test('$MethodChannelGlucosemeterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGlucosemeterPlugin>());
  });

  test('getPlatformVersion', () async {
    GlucosemeterPlugin glucosemeterPlugin = GlucosemeterPlugin();
    MockGlucosemeterPluginPlatform fakePlatform = MockGlucosemeterPluginPlatform();
    GlucosemeterPluginPlatform.instance = fakePlatform;

    expect(await glucosemeterPlugin.getPlatformVersion(), '42');
  });
}
