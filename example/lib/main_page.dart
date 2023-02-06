import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin.dart';
import 'package:glucosemeter_plugin_example/model/glucosemeter_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'device_info.dart';
import 'model/glucosemeter_result_type.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final GlucosemeterPlugin glucosemeterPlugin = GlucosemeterPlugin();
  FlutterBluePlus  flutterBlue = FlutterBluePlus.instance;
  List<GlucosemeterResult> glucosemeterResult = [];
  late StreamSubscription streamSubscription;

  String currentResultType = '';
  String currentData = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      initGlucosemeterPlugin();
    });

    flutterBlue.startScan();
  }

  Future<void> initGlucosemeterPlugin() async {
    List<Permission> permissionList = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices
    ];

    Map<Permission, PermissionStatus> permissionResult = await permissionList.request();
    //https://www.soft-spoken.dev/how-to-listen-for-platform-specific-events-in-flutter/

    streamSubscription = glucosemeterPlugin.getBluetoothStream().listen((event) {
      setState(() {
        glucosemeterResult.add(GlucosemeterResult.fromJson(jsonDecode(event)));
      });

      if(glucosemeterResult.isNotEmpty){
        setState(() {
          currentResultType = processResultType(glucosemeterResult.last.type ?? '', glucosemeterResult.last.data);
          currentData = processResultData(glucosemeterResult.last.type ?? '', glucosemeterResult.last.data);
        });
      }
    });

    await glucosemeterPlugin.automaticConnectBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glucosemeter Plugin Example App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildGlucosemeterPluginControls(),
              _buildGlucosemeterCurrentState(),
              _buildGlucosemeterPluginProcessedResult(),
              // _buildFlutterBlueConnectedDevices(),
              // _buildFlutterBlueScanDevice(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlucosemeterCurrentState(){
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Current status:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentResultType,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Data:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    currentData,
                    style: const TextStyle(
                      fontSize: 16,
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlucosemeterPluginProcessedResult(){
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: glucosemeterResult.length,
      itemBuilder: (context, index){
        return Column(
          children: [
            Text(glucosemeterResult[index].type ?? 'No type'),
            Text(glucosemeterResult[index].data ?? 'No data'),
          ],
        );
      },
    );
  }

  Widget _buildGlucosemeterPluginControls(){
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Glucosemeter Plugin Controls'),
          children: [
            Wrap(
              spacing: 2.0,
              children: [
                Platform.isAndroid ? TextButton(
                  child: const Text('Turn on Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.openBluetooth();
                  },
                ) : Container(),
                Platform.isAndroid ? TextButton(
                  child: const Text('Turn off Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.closeBluetooth();
                  },
                ) : Container(),
                TextButton(
                  child: const Text('Automatic Connect Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.automaticConnectBluetooth();
                  },
                ),
                TextButton(
                  child: const Text('Disconnect Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.disconnectBluetooth();
                  },
                ),
                TextButton(
                  child: const Text('Scan Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.scanBluetooth();
                    // print(result);
                  },
                ),
                TextButton(
                  child: const Text('Connected Bluetooth Device Address'),
                  onPressed: () async {
                    String? result = await glucosemeterPlugin.connectedBluetoothDeviceAddress();
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? 'null')));
                    // print(result);
                  },
                ),
                TextButton(
                  child: const Text('Bluetooth State'),
                  onPressed: () async {
                    bool? result = await glucosemeterPlugin.bluetoothState();
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString())));
                    // print(result);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String processResultType(String type, String? data){
    if(type == ResultType.searchStarted.toShortString()){
      return 'Search started';
    }

    if(type == ResultType.searchStopped.toShortString()){
      return 'Search Stopped';
    }

    if(type == ResultType.onDeviceSpyListener.toShortString()){
      if(data != null){
        return 'Device Connected';
      }else{
        return 'Searching';
      }
    }

    if(type == ResultType.deviceBreak.toShortString()){
      return 'Searching';
    }

    if(type == ResultType.onDeviceConnectSucceed.toShortString()){
      return 'Device Connected Successfully';
    }

    if(type == ResultType.concentrationResultReceived.toShortString()){
      return 'Concentration Result Received';
    }

    if(type == ResultType.testPaperListened.toShortString()){
      return 'Test Paper Detected';
    }

    if(type == ResultType.onBleedResultListened.toShortString()){
      //等待滴血 - From docs
      return 'Waiting for Blood';
    }

    if(type == ResultType.onDownTimeListened.toShortString()){
      return 'Counting Down Timer';
    }

    if(type == ResultType.errorTypeListener.toShortString()){
      return 'Device Error Detected';
    }

    if(type == ResultType.memorySyncListener.toShortString()){
      return 'Device Memory Synced';
    }

    if(type == ResultType.deviceResultListener.toShortString()){
      return 'Device Information Received';
    }

    if(type == ResultType.bluetoothRssi.toShortString()){
      return 'Device RSSI Received';
    }

    if(type == ResultType.onDeviceConnectFailing.toShortString()){
      return 'Bluetooth Connection Failed';
    }

    return 'dafuq';
  }

  String processResultData(String type, String? data){
    if(type == ResultType.onDeviceSpyListener.toShortString()){
      if(data != null){
        return data;
      }
    }

    if(type == ResultType.concentrationResultReceived.toShortString()){
      if(data != null){
        Map<String, String> map = jsonDecode(data);
        return 'Concentration: ${map['concentration']} \n'
            'Timestamp: ${map['timeStamp']}';
      }
    }

    if(type == ResultType.onDownTimeListened.toShortString()){
      return 'Timer: $data';
    }

    if(type == ResultType.errorTypeListener.toShortString()){
      return 'Error: $data';
    }

    if(type == ResultType.memorySyncListener.toShortString()){
      // Not sure yet
      return 'Memory: $data';
    }

    if(type == ResultType.deviceResultListener.toShortString()){
      if(data != null){
        Map<String, String> map = jsonDecode(data);
        return 'Model: ${map['model']} \n'
            'Device Procedure: ${map['deviceProcedure']} \n'
            'Device Version: : ${map['deviceVersion']}';
      }
    }

    if(type == ResultType.bluetoothRssi.toShortString()){
      return 'RSSI $data';
    }

    if(type == ResultType.onDeviceConnectFailing.toShortString()){
      return 'Code: $data';
    }

    return 'No Data';
  }

  Widget _buildFlutterBlueConnectedDevices(){
    return Card(
      child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Connected devices',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ),
              ),
              FutureBuilder(
                future: flutterBlue.connectedDevices,
                builder: (context, snapshot){
                  if(snapshot.data == null) return const Text('No connected devices');
                  if(snapshot.data!.isEmpty) return const Text('No connected devices');

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].name),
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_){
                                      return DeviceInfo(bluetoothDevice: snapshot.data![index]);
                                    }
                                )
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )
      ),
    );
  }

  Widget _buildFlutterBlueScanDevice(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Scanned Devices',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
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
                          try{
                            await snapshot.data![index].device.connect();
                            if(!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connected')));
                          }catch(e){
                            print(e);
                            if(!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                          // await glucosemeterPlugin.attachBluetoothListener();
                        },
                        onLongPress: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_){
                                return DeviceInfo(bluetoothDevice: snapshot.data![index].device);
                              }
                            )
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
