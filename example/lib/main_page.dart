import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:glucosemeter_plugin/glucosemeter_plugin.dart';

import 'device_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final GlucosemeterPlugin glucosemeterPlugin = GlucosemeterPlugin();
  FlutterBluePlus  flutterBlue = FlutterBluePlus.instance;

  @override
  void initState() {
    super.initState();
    glucosemeterPlugin.initGlucoseBluetoothUtil();
    glucosemeterPlugin.automaticConnectBluetooth();
    flutterBlue.startScan();
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
              _buildFlutterBlueConnectedDevices(),
              _buildFlutterBlueScanDevice(),
            ],
          ),
        ),
      ),
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
                TextButton(
                  child: const Text('Turn on Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.openBluetooth();
                  },
                ),
                TextButton(
                  child: const Text('Turn off Bluetooth'),
                  onPressed: () async {
                    await glucosemeterPlugin.closeBluetooth();
                  },
                ),
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
                    await glucosemeterPlugin.openBluetooth();
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
                          await snapshot.data![index].device.connect();
                          // await glucosemeterPlugin.attachBluetoothListener();
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
