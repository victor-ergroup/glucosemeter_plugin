import 'dart:async';

import 'package:convert/convert.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'blood_glucose_concentration.dart';
import 'blood_glucose_event.dart';

class GlucosemeterDataExtractor {
  static final uuidService = Guid("0000fff0-0000-1000-8000-00805f9b34fb");
  static final uuidRead = Guid("0000fff1-0000-1000-8000-00805f9b34fb");
  static final uuidWrite = Guid("0000fff2-0000-1000-8000-00805f9b34fb");

  final uuidServiceInfo = Guid("0000180a-0000-1000-8000-00805f9b34fb");

  BluetoothCharacteristic? cRead;
  BluetoothCharacteristic? cWrite;

  GlucosemeterDataExtractor(BluetoothDevice device) {
    BluetoothService? service = device.servicesList.where(
      (s) => s.uuid == uuidService
    ).firstOrNull;
    if (service != null) {
      cRead = service.characteristics.where((c) => c.uuid == uuidRead).firstOrNull;
      cWrite = service.characteristics.where((c) => c.uuid == uuidWrite).firstOrNull;
    }
  }

  get canNotify {
    return cRead != null && cRead!.properties.notify;
  }

  Stream<List<int>> subscribe() {
    if (cRead != null) {
      if (cRead!.properties.notify) {
        cRead!.setNotifyValue(true);
        return cRead!.onValueReceived;
      } else {
        throw Exception("Not ready.");
      }
    } else {
      throw Exception("Not supported device.");
    }
  }

  get canRead {
    return cRead != null && cRead!.properties.read;
  }

  Future<String> readData() async {
    if (cRead != null) {
      if (cRead!.properties.read) {
        return convertRawToString(await cRead!.read());
      } else {
        return "Not ready.";
      }
    } else {
      return "Not supported device.";
    }
  }

  get canWrite {
    return cWrite != null && cWrite!.properties.write;
  }

  Future<void> writeData(String data) {
    if (cWrite != null) {
      if (cWrite!.properties.write) {
        return cWrite!.write(hex.decode(data));
      } else {
        throw Exception("Not ready.");
      }
    } else {
      throw Exception("Not supported device.");
    }
  }

  List<String> stringSpilt(String s, int len) {
    int cache = len;
    int spiltNum = s.length ~/ len;
    List<String> subs = [];
    int strLen;
    if (s.length % len > 0) {
      strLen = spiltNum + 1;
    } else {
      strLen = spiltNum;
    }
    int start = 0;
    if (spiltNum > 0) {
      for (int i = 0; i < strLen; ++i) {
        if (i == 0) {
          subs[0] = s.substring(start, len);
          start = len;
        } else if (i > 0 && i < strLen - 1) {
          len += cache;
          subs[i] = s.substring(start, len);
          start = len;
        } else {
          subs[i] = s.substring(len, s.length);
        }
      }
    }

    return subs;
  }

  BloodGlucoseConcentration dataTransition(String str) {
    String concentration = (int.parse(str.substring(10, 12) + str.substring(8, 10), radix: 16) / 8).toString();
    return BloodGlucoseConcentration(concentration, DateTime.now().toString());
  }

  List<String> histories = [];

  BloodGlucoseEvent handleSubscribeData(List<int> rawResult) {
    String result = convertRawToString(rawResult).toUpperCase();
    bool bReceivingHistoricalData = false;
    String datas = "";
    if (result.startsWith("FAAAAAAF") && result.endsWith("F55F")) {
      datas = result;
    } else {
      if (result.substring(0, 8) == "FAAAAAAF" && result.substring(12, 14) == "2F") {
        bReceivingHistoricalData = true;
      }

      if (bReceivingHistoricalData) {
        bool bFound = false;
        for (int i = 0; i < histories.length; ++i) {
          if (histories[i] == result) {
            bFound = true;
            break;
          }
        }
        if (!bFound) {
          histories.add(result);
        }
        if (result.lastIndexOf("F55F") != -1) {
          bReceivingHistoricalData = false;
          datas = "";
        }
      }
    }

    if (!bReceivingHistoricalData) {
      if (datas.length >= 20) {
        String type = datas.substring(12, 14);
        String bloodData = "";
        if (datas.length > 20) {
          bloodData = datas.substring(14, datas.length - 6);
        }
        // String dataLength = datas.substring(8, 12);
        // String verifySun = datas.substring(datas.length - 6, datas.length - 4);
        // if (!makeChecksum(bloodData, dataLength, type).equals(verifySun)) {
        // }

        switch (type) {
          case "04":
            return BloodGlucoseEvent(
              BloodGlucoseEvent.RESULT_TYPE, bloodData.toString()
            );
          case "06":
          case "09":
            return BloodGlucoseEvent(
              BloodGlucoseEvent.EVENT_TYPE, "Test Paper Inserted."
            );
          case "0A":
            return BloodGlucoseEvent(
              BloodGlucoseEvent.EVENT_TYPE, "Reading on Blood."
            );
          case "0B":
            return BloodGlucoseEvent(
              BloodGlucoseEvent.EVENT_TYPE, "waiting for ${int.parse(bloodData, radix: 16)}"
            );
          case "0C":
          case "0D":
          case "0E":
          case "0F":
          case "10":
          case "11":
            String errorCode = (int.parse(type[0]) + 1).toString() + type[1];
            return BloodGlucoseEvent(
              BloodGlucoseEvent.ERROR_TYPE, getErrorMessage(errorCode)
            );
          case "2F": // concentration info
            List<BloodGlucoseConcentration> results = [];
            List<String> strings = stringSpilt(bloodData, 12);
            List<String> var13 = strings;
            int var14 = strings.length;

            for (int var15 = 0; var15 < var14; ++var15) {
              String str = var13[var15];
              results.add(dataTransition(str));
            }
            return BloodGlucoseEvent(
              BloodGlucoseEvent.RESULT_TYPE,
              results.map((x) => x.toString()).join("\n")
            );
          case "19": // device info
            return BloodGlucoseEvent(BloodGlucoseEvent.EVENT_TYPE, "DEVICE INFO");
        // case "06":
        //   return BloodGlucoseEvent(BloodGlucoseEvent.EVENT_TYPE, "PENDING");
        }
      }
    }
    return BloodGlucoseEvent(BloodGlucoseEvent.OTHER_TYPE, "");
  }

  static const BLOOD_GLUCOSE_ER1_RES = "8C";
  static const BLOOD_GLUCOSE_ER2_RES = "8D";
  static const BLOOD_GLUCOSE_ER3_RES = "8E";
  static const BLOOD_GLUCOSE_ER4_RES = "8F";
  static const BLOOD_GLUCOSE_ER5_RES = "90";
  static const BLOOD_GLUCOSE_ER6_RES = "91";

  getErrorMessage(String msg) {
    switch (msg) {
      case BLOOD_GLUCOSE_ER1_RES:
        return "An error occurred when the device turning on";
      case BLOOD_GLUCOSE_ER2_RES:
        return "The test strip has been used or contaminated";
      case BLOOD_GLUCOSE_ER3_RES:
        return "It is too early to add blood to the blood sugar test strip";
      case BLOOD_GLUCOSE_ER4_RES:
        return "The test strip was moved or the sample was not stable during the test";
      case BLOOD_GLUCOSE_ER5_RES:
        return "The model of the blood glucose test strip does not match";
      case BLOOD_GLUCOSE_ER6_RES:
      default:
        return "Other issues";
    }
  }

  static Future<void> test(BluetoothDevice device,
      {List<Guid>? serviceUuids, List<Guid>? characteristicUUids}) async {
    print("start test, total ${device.servicesList.length} services.");
    for (BluetoothService s in device.servicesList.where((x) => serviceUuids == null || serviceUuids.contains(x.uuid))) {
      for (BluetoothCharacteristic c in s.characteristics.where((x) =>
      characteristicUUids == null ||
          characteristicUUids.contains(x.uuid))) {
        print(c.descriptors);
        print("Service UUID: ${c.serviceUuid}");
        print("UUID: ${c.uuid}");
        print("Can Notify: ${c.properties.notify}");
        print("Can Read: ${c.properties.read}");
        print("Can Write: ${c.properties.write}");
        if (c.properties.notify) {
          c.setNotifyValue(true);
          StreamSubscription ss = c.onValueReceived.listen((List<int> x) => print("${c.uuid} notify: ${convertRawToString(x)}"));
          device.cancelWhenDisconnected(ss);
        }
        if (c.properties.read) {
          print("${c.uuid}: ${convertRawToString(await c.read())}");
        }
      }
    }
  }

  static String convertRawToString(List<int> bytes) {
    return hex.encode(bytes);
  }
}
