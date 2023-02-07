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
        title: const Text('Device Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildDisplayItem(
                title: 'Name',
                data: widget.bluetoothDevice.name
              ),
              _buildDisplayItem(
                title: 'ID',
                data: widget.bluetoothDevice.id.id
              ),
              FutureBuilder(
                future: widget.bluetoothDevice.readRssi(),
                builder: (context, snapshot){
                  return _buildDisplayItem(
                    title: 'RSSI',
                    data: snapshot.data.toString()
                  );
                },
              ),
              _buildDisplayItem(
                title: 'Type',
                data: widget.bluetoothDevice.type.name
              ),
              _buildCustomDisplayItem(
                title: 'Services',
                widget: StreamBuilder(
                  stream: widget.bluetoothDevice.services,
                  builder: (context, snapshot){
                    if(snapshot.data == null) return const Text('No service - null');
                    if(snapshot.data!.isEmpty) return const Text('No service');
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            _buildCharacteristicsList(snapshot.data![index].characteristics),
                            _buildBluetoothServiceList(snapshot.data![index].includedServices)
                          ],
                        );
                      },
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacteristicsList(List<BluetoothCharacteristic> characteristic){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: characteristic.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text('UUID - ${characteristic[index].uuid.toString()}'),
          subtitle: Text('Read - ${characteristic[index].properties.read} | Write - ${characteristic[index].properties.write}'),
        );
      },
    );
  }

  Widget _buildBluetoothServiceList(List<BluetoothService> service){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: service.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text('Device ID - ${service[index].deviceId.toString()}'),
          subtitle: Text(service[index].includedServices.toString()),
        );
      },
    );
  }

  Widget _buildDisplayItem({required String title, required String data}){
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(
            minWidth: 100
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontSize: 18
          ),
        )
      ],
    );
  }

  Widget _buildCustomDisplayItem({required String title, required Widget widget}){
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(
              minWidth: 100
          ),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        widget
      ],
    );
  }

}
