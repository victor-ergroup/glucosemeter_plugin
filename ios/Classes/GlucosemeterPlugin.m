#import "GlucosemeterPlugin.h"
#import "JTManager+BloodSugar.h"

@implementation GlucosemeterPlugin{
    NSArray *deviceList;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"glucosemeter_plugin"
            binaryMessenger:[registrar messenger]];
  GlucosemeterPlugin* instance = [[GlucosemeterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//    self.manager = [JTManager shareInstance];
    //    self.manager.name = self.deviceName;
  [self.manager initBloodSugarDataDelegate];

  self.manager.delegate = self;
  self.manager.bloodSugar_delegate = self;
    
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"automaticConnectBluetooth" isEqualToString:call.method]){
      [self automaticConnectBluetooth:call result:result];
  }else if ([@"scanBluetooth" isEqualToString:call.method]){
      [self scanBluetooth:call result:result];
  }else if ([@"stopScan" isEqualToString:call.method]){
      [self stopScan:call result:result];
  }else if ([@"disconnectBluetooth" isEqualToString:call.method]){
      [self disconnectBluetooth:call result:result];
  }else if ([@"connectedDeviceName" isEqualToString:call.method]){
      [self connectedDeviceName:call result:result];
  }else if ([@"connectedBluetoothDeviceAddress" isEqualToString:call.method]){
      [self connectedBluetoothDeviceAddress:call result:result];
  }else if ([@"connectedBluetoothDeviceRssi" isEqualToString:call.method]){
      [self connectedBluetoothDeviceRssi:call result:result];
  }else if ([@"bluetoothState" isEqualToString:call.method]){
      [self bluetoothState:call result:result];
  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)initBluetooth:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"initBluetooth executed");
    deviceList = @[
       @"BG-211b",
       @"BG-207b",
       @"BG-208b",
       @"BG-209b",
       @"BG-707b",
       @"BG-709b",
       @"BG-210b",
       @"BG-710b",
       @"BG-211b",
       @"BG-212b",
       @"BG-712b"
    ];
}

- (void)scanBluetooth:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"scanBluetooth executed");
    [self.manager startScan];
}

- (void)stopScan:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"stopScan executed");
    [self.manager cancelScan];
}

- (void)automaticConnectBluetooth:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"automaticConnectBluetooth executed");
    [self.manager autoConnect];
    result(NULL);
}

- (void)disconnectBluetooth:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"disconnectBluetooth executed");
    [self.manager allDisconnect];
    result(NULL);
}

- (void)connectedDeviceName:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"connectedDeviceName executed");
    result(self.manager.connectedPeripheral.name);
}

- (void)connectedBluetoothDeviceAddress:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"connectedBluetoothDeviceAddress executed");
    result(self.manager.connectedPeripheral.identifier);
}

- (void)connectedBluetoothDeviceRssi:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"connectedBluetoothDeviceAddress executed");
    [self.manager.connectedPeripheral readRSSI];
    result(NULL);
}

- (void)bluetoothState:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"bluetoothState executed");
    
    BOOL isConnected = self.manager.isConnected;
    NSNumber *tempIsConnected = [NSNumber numberWithBool:isConnected];

    result(tempIsConnected);
}

@end
