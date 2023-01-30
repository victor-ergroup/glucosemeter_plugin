import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _glucosemeterPlugin = GlucosemeterPlugin();

  FlutterBluePlus  flutterBlue = FlutterBluePlus .instance;
  List<ScanResult> bluetoothScanResultList = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _glucosemeterPlugin.initGlucoseBluetoothUtil();
    flutterBlue.startScan();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _glucosemeterPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Running on: $_platformVersion\n'),
                TextButton(
                  child: const Text('Bluetooth State'),
                  onPressed: () async {
                    await _glucosemeterPlugin.openBluetooth();
                    _glucosemeterPlugin.attachBluetoothListener();
                    bool? result = await _glucosemeterPlugin.bluetoothState();
                    print(result);
                    // print(result);
                  },
                ),
                StreamBuilder(
                  stream: flutterBlue.isScanning,
                  builder: (context, snapshot){
                    if(snapshot.data == false){
                      return TextButton(
                        child: const Text('Scan'),
                        onPressed: (){
                          flutterBlue.startScan();
                        },
                      );
                    }else{
                      return TextButton(
                        child: const Text('Stop Scan'),
                        onPressed: (){
                          flutterBlue.stopScan();
                        },
                      );
                    }
                  },
                ),
                StreamBuilder(
                  stream: flutterBlue.scanResults,
                  builder: (context, snapshot){
                    if(snapshot.data == null) return const Text('Null');
                    if(snapshot.data!.isEmpty) return const Text('Empty');
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].device.name),
                            subtitle: Text(snapshot.data![index].device.type.name),
                            trailing: Text(snapshot.data![index].advertisementData.connectable.toString()),
                            onTap: () async {
                              await snapshot.data![index].device.connect();
                              await _glucosemeterPlugin.attachBluetoothListener();
                              // await _glucosemeterPlugin.connectBluetooth(snapshot.data![index].device);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: bluetoothScanResultList.length,
                //   itemBuilder: (context, index){
                //     return ListTile(
                //       title: Text(bluetoothScanResultList[index].device.name),
                //       subtitle: Text(bluetoothScanResultList[index].device.type.name),
                //     );
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
