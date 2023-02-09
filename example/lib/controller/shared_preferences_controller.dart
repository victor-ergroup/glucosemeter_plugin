import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/blood_glucose_data.dart';

class SharedPreferencesController {
  static late SharedPreferences sharedPreferences;

  static Future setConcentrationData({required BloodGlucoseData bloodGlucoseData}) async {
    sharedPreferences = await SharedPreferences.getInstance();

    List<BloodGlucoseData> bloodGlucoseDataList = await getConcentrationData();
    bloodGlucoseDataList.add(bloodGlucoseData);

    await sharedPreferences.setString("concentration", jsonEncode(bloodGlucoseDataList));
  }

  static Future<List<BloodGlucoseData>> getConcentrationData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? concentrationDataString = sharedPreferences.getString("concentration");
    List<BloodGlucoseData> bloodGlucoseDataList = [];

    if(concentrationDataString != null){
      bloodGlucoseDataList = (jsonDecode(concentrationDataString) as List).map((e) => BloodGlucoseData.fromJson(e)).toList();
    }

    return bloodGlucoseDataList;
  }

  static Future<bool> clearConcentrationData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.clear();
  }
}