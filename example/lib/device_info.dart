import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceInfo extends StatefulWidget {

  final BluetoothDevice bluetoothDevice;

  const DeviceInfo({Key? key, required this.bluetoothDevice}) : super(key: key);

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Name: ${widget.bluetoothDevice.name}'),
            Text('Id: ${widget.bluetoothDevice.id.id}'),
            FutureBuilder(
              future: widget.bluetoothDevice.readRssi(),
              builder: (context, snapshot){
                return Text('RSSI: ${snapshot.data}');
              },
            ),
            Text('Type: ${widget.bluetoothDevice.type.name}'),
            Text('Services'),
            StreamBuilder(
              stream: widget.bluetoothDevice.services,
              builder: (context, snapshot){
                if(snapshot.data == null) return const Text('No service');
                if(snapshot.data!.isEmpty) return const Text('No service');
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(snapshot.data![index].characteristics.first.toString()),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
