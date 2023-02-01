#import "GlucosemeterPlugin.h"
#import "JTManager+BloodSugar.h"

@implementation GlucosemeterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"glucosemeter_plugin"
            binaryMessenger:[registrar messenger]];
  GlucosemeterPlugin* instance = [[GlucosemeterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"automaticConnectBluetooth" isEqualToString:call.method]){
      [super automaticConnectBluetooth:call:call result:result];
  }else {
    result(FlutterMethodNotImplemented);
  }
}

+ (void)automaticConnectBluetooth:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"test");
}

@end
