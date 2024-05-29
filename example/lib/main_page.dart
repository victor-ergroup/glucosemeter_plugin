import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin.dart';
import 'package:glucosemeter_plugin_example/controller/shared_preferences_controller.dart';
import 'package:glucosemeter_plugin/model/glucosemeter_result.dart';
import 'package:glucosemeter_plugin/model/glucosemeter_connect_status.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:glucosemeter_plugin/model/blood_glucose_data.dart';
import 'model/glucosemeter_result_type.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final GlucosemeterPlugin glucosemeterPlugin = GlucosemeterPlugin();
  List<GlucosemeterResult> glucosemeterResult = [];
  List<BloodGlucoseData> bloodGlucoseDataList = [];
  late StreamSubscription streamSubscription;

  String currentResultType = '';
  String currentData = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      initGlucosemeterPlugin();
    });

    getSharedPrefData();
  }

  Future<void> getSharedPrefData() async {
    List<BloodGlucoseData> tempBloodGlucoseDataList = await SharedPreferencesController.getConcentrationData();
    setState(() {
      bloodGlucoseDataList = tempBloodGlucoseDataList;
    });
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

    streamSubscription = glucosemeterPlugin.getBluetoothStream().listen((event) async {
      setState(() {
        glucosemeterResult.add(event);
      });

      if(glucosemeterResult.isNotEmpty){
        String resultData = await processResultData(glucosemeterResult.last.type ?? '', glucosemeterResult.last.data);
        setState(() {
          currentResultType = processResultType(glucosemeterResult.last.type ?? '', glucosemeterResult.last.data);
          currentData = resultData;
        });
      }
    });

    // await glucosemeterPlugin.automaticConnectBluetooth();
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
              _buildSavedResults(),
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
                TextButton(
                  child: const Text('Connected Device Name'),
                  onPressed: () async {
                    String? result = await glucosemeterPlugin.connectedDeviceName();
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString())));
                    // print(result);
                  },
                ),
                TextButton(
                  child: const Text('Get Platform Version'),
                  onPressed: () async {
                    String? result = await glucosemeterPlugin.getPlatformVersion();
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
        return 'Searching';
      }else{
        return 'Device connected';
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

  Future<String> processResultData(String type, String? data) async {
    if(type == ResultType.onDeviceSpyListener.toShortString()){
      if(data != null){
        GlucosemeterConnectStatus glucosemeterConnectStatus = GlucosemeterConnectStatus.fromJson(jsonDecode(data));
        return glucosemeterConnectStatus.toJson().toString();
      }
    }

    if(type == ResultType.concentrationResultReceived.toShortString()){
      if(data != null){
        BloodGlucoseData bloodGlucoseData = BloodGlucoseData.fromJson(jsonDecode(data));
        SharedPreferencesController.setConcentrationData(
          bloodGlucoseData: bloodGlucoseData
        );
        getSharedPrefData();
        return 'Concentration: ${bloodGlucoseData.concentration} \n'
            'Timestamp: ${bloodGlucoseData.timestamp}';
      }
    }

    if(type == ResultType.onDownTimeListened.toShortString()){
      return 'Timer: $data';
    }

    if(type == ResultType.errorTypeListener.toShortString()){
      return 'Error: ${jsonDecode(data!)['message']}';
    }

    if(type == ResultType.memorySyncListener.toShortString()){
      print(data);
      Map<String, dynamic> map = jsonDecode(data!);
      // List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(jsonDecode(map['message']));
      // return 'Memory: ${result.first['concentration']} - ${result.first['timestamp']}';
    }

    if(type == ResultType.deviceResultListener.toShortString()){
      if(data != null){
        Map<String, dynamic> map = jsonDecode(data);
        return 'Model: ${map['model']} \n'
            'Device Procedure: ${map['deviceProcedure']} \n'
            'Device Version: : ${map['deviceVersion']}';
      }
    }

    if(type == ResultType.bluetoothRssi.toShortString()){
      return 'RSSI ${jsonDecode(data!)['message']}';
    }

    if(type == ResultType.onDeviceConnectFailing.toShortString()){
      return 'Code: ${jsonDecode(data!)['message']}';
    }

    return 'No Data';
  }

  Widget _buildSavedResults(){
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Saved History'),
          children: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                child: const Text('Clear'),
                onPressed: () async {
                  bool result = await SharedPreferencesController.clearConcentrationData();
                  if(result){
                    await getSharedPrefData();
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Cleared')));
                  }
                },
              ),
            ),
            bloodGlucoseDataList.isNotEmpty ? SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: bloodGlucoseDataList.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(bloodGlucoseDataList[index].concentration ?? ''),
                    subtitle: Text(bloodGlucoseDataList[index].timestamp ?? ''),
                  );
                },
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
