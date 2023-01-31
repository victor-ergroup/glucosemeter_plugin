package com.example.glucosemeter_plugin;

import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import com.cj.bluetoothlibrary.BluetoothDevices;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseBean;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseBluetoothUtil;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseDeviceBean;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseErBean;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** GlucosemeterPlugin */
public class GlucosemeterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Activity activity;
  private Context context;
  private BloodGlucoseBluetoothUtil bloodGlucoseBluetoothUtil;

  public void openBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try{
      bloodGlucoseBluetoothUtil.openBluetooth();
      Log.i("GLUCOSEMETERPLUGIN", "openBluetooth executed");
      result.success(null);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void closeBluetooth(@NonNull MethodCall call, @NonNull Result result){
    activity.runOnUiThread(() -> {
      try {
        bloodGlucoseBluetoothUtil.closeBluetooth();
        Log.i("GLUCOSEMETERPLUGIN", "closeBluetooth executed");
        result.success(null);
      }catch (Exception e){
        Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
        result.error("ERROR", e.getMessage(), e.getCause());
      }
    });
  }

  public void scanBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.scanBluetooth();
      Log.i("GLUCOSEMETERPLUGIN", "scanBluetooth executed");
      result.success(null);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void stopScan(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.stopBluetooth();
      Log.i("GLUCOSEMETERPLUGIN", "stopBluetooth executed");
      result.success(null);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  // NOTE: Cannot be used.
  public void connectBluetooth(@NonNull MethodCall call, @NonNull Result result){
    activity.runOnUiThread(() -> {
      try {
        BluetoothDevice bluetoothDevice = call.argument("bluetoothDevice");
        bloodGlucoseBluetoothUtil.connectBluetooth(bluetoothDevice);
        result.success(null);
      }catch (Exception e){
        Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
        result.error("ERROR", e.getMessage(), e.getCause());
      }
    });
  }

  public void automaticConnectBluetooth(@NonNull MethodCall call, @NonNull Result result){
    activity.runOnUiThread(() -> {
      try {
        bloodGlucoseBluetoothUtil.connectAutomaticBluetooth();
        Log.i("GLUCOSEMETERPLUGIN", "automaticConnectBluetooth executed");
        result.success(true);
      }catch (Exception e){
        Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
        result.error("ERROR", e.getMessage(), e.getCause());
      }
    });
  }

  public void disconnectBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.breakBluetooth();
      Log.i("GLUCOSEMETERPLUGIN", "disconnectBluetooth executed");
      result.success(true);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectedDeviceName(@NonNull MethodCall call, @NonNull Result result){
    try {
      String deviceName = bloodGlucoseBluetoothUtil.connectBluetoothDeviceName();
      Log.i("GLUCOSEMETERPLUGIN", "connectedDeviceName executed - " + deviceName);
      result.success(deviceName);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectedBluetoothDeviceAddress(@NonNull MethodCall call, @NonNull Result result){
    try {
      String deviceAddress = bloodGlucoseBluetoothUtil.connectBluetoothDeviceAddress();
      Log.i("GLUCOSEMETERPLUGIN", "connectedBluetoothDeviceAddress executed - " + deviceAddress);
      result.success(deviceAddress);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectedBluetoothDeviceRssi(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.connectBluetoothRssi();
      Log.i("GLUCOSEMETERPLUGIN", "connectedBluetoothDeviceRssi executed");
      result.success(null);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void bluetoothState(@NonNull MethodCall call, @NonNull Result result){
    try {
      boolean state = bloodGlucoseBluetoothUtil.stateBluetooth();
      Log.i("GLUCOSEMETERPLUGIN", "connectedBluetoothDeviceAddress executed - " + state);
      result.success(state);
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void attachBluetoothListener(@NonNull MethodCall call, @NonNull Result result){
    Log.i("GLUCOSEMETER:INFO", "bluetoothListener attached");
    activity.runOnUiThread(() -> bloodGlucoseBluetoothUtil.setBloodBluetoothListener(new BloodGlucoseBluetoothUtil.OnBloodBluetoothListener() {
      @Override
      public void onSearchStarted() {
        Log.i("GLUCOSEMETER:INFO", "onSearchStarted runned");
      }

      @Override
      public void onSearchStopped() {
        Log.i("GLUCOSEMETER:INFO", "onSearchStopped runned");
      }

      @Override
      public void onDeviceSpyListener(BluetoothDevice bluetoothDevice, Integer integer) {
        Log.i("GLUCOSEMETER:INFO", "onDeviceSpyListener runned");
      }

      @Override
      public void onDeviceBreakListener() {
        Log.i("GLUCOSEMETER:INFO", "onDeviceBreakListener runned");
      }

      @Override
      public void onDeviceConnectSucceed() {
        Log.i("GLUCOSEMETER:INFO", "onDeviceConnectSucceed runned");
      }

      @Override
      public void onConcentrationResultListener(BloodGlucoseBean bloodGlucoseBean) {
        HashMap<String, String> resultMap = new HashMap<>();
        resultMap.put("concentration", bloodGlucoseBean.getConcentration());
        resultMap.put("timeStamp", bloodGlucoseBean.getTimestamp());

        Log.i("GLUCOSEMETER:INFO", "onConcentrationResultListener runned: " + bloodGlucoseBean.toString());
//        result.success(resultMap);
      }

      @Override
      public void onTestPaperResultListener() {
        Log.i("GLUCOSEMETER:INFO", "onTestPaperResultListener runned");
      }

      @Override
      public void onBleedResultListener() {
        Log.i("GLUCOSEMETER:INFO", "onBleedResultListener runned");
      }

      @Override
      public void onDownTimeResultListener(int i) {
        Log.i("GLUCOSEMETER:INFO", "onDownTimeResultListener runned");
      }

      @Override
      public void onErTypeResultListener(String s) {
        String message = "";
        switch (s){
          case BloodGlucoseErBean.BLOOD_GLUCOSE_ER1_RES:
            message = "开机自检错误";
            break;
          case BloodGlucoseErBean.BLOOD_GLUCOSE_ER2_RES:
            message = "血糖试纸已使用过或被污染";
            break;
          case BloodGlucoseErBean.BLOOD_GLUCOSE_ER3_RES:
            message = "在血糖试纸上加血时间过早";
            break;
          case BloodGlucoseErBean.BLOOD_GLUCOSE_ER4_RES:
            message = "测试过程中，试纸被移动 或采样不稳";
            break;
          case BloodGlucoseErBean.BLOOD_GLUCOSE_ER5_RES:
            message = "血糖试纸型号不匹配";
            break;
          case BloodGlucoseErBean.BLOOD_GLUCOSE_ER6_RES:
            message = "其他问题";
            break;
        }
        Log.i("GLUCOSEMETER:INFO", message);
//        result.success(message);
      }

      @Override
      public void onMemorySynListener(List<BloodGlucoseBean> list) {
        StringBuilder data = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
          data.append("\n"+(i + 1))
                  .append("\n时间戳：")
                  .append(list.get(i).getTimestamp())
                  .append("\n浓度：")
                  .append(list.get(i).getConcentration());
        }
        Log.i("GLUCOSEMETER:INFO", "Received from memory" + data);
      }

      @Override
      public void onDeviceResultListener(BloodGlucoseDeviceBean bloodGlucoseDeviceBean) {
        //仪器主要信息
        StringBuilder data = new StringBuilder();
        data.append("仪器主要信息：")
                .append("\n型号：")
                .append(bloodGlucoseDeviceBean.getDevice_model())
                .append("\n程序编码：")
                .append(bloodGlucoseDeviceBean.getDevice_procedure())
                .append("\n版本：")
                .append(bloodGlucoseDeviceBean.getDevice_versions());
        Log.i("GLUCOSEMETER:INFO", "Received device info: " + data);
      }

      @Override
      public void onReadBluetoothRssi(Integer integer) {
        Log.i("GLUCOSEMETER:INFO", "onReadBluetoothRssi runned: " + integer.toString());
      }

      @Override
      public void onDeviceConnectFailing(int i) {
        Log.i("GLUCOSEMETER:INFO", "onDeviceConnectFailing runned: " + i);
      }
    }));
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    bloodGlucoseBluetoothUtil = new BloodGlucoseBluetoothUtil(context);
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "glucosemeter_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "getPlatformVersion" :
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "openBluetooth" :
        openBluetooth(call, result);
        break;
      case "closeBluetooth" :
        closeBluetooth(call, result);
        break;
      case "scanBluetooth" :
        scanBluetooth(call, result);
        break;
      case "stopScan" :
        stopScan(call, result);
        break;
      case "connectBluetooth" :
        connectBluetooth(call, result);
        break;
      case "automaticConnectBluetooth" :
        automaticConnectBluetooth(call, result);
        break;
      case "disconnectBluetooth" :
        disconnectBluetooth(call, result);
        break;
      case "connectedDeviceName" :
        connectedDeviceName(call, result);
        break;
      case "connectedBluetoothDeviceAddress" :
        connectedBluetoothDeviceAddress(call, result);
        break;
      case "connectedBluetoothDeviceRssi" :
        connectedBluetoothDeviceRssi(call, result);
      case "bluetoothState" :
        bluetoothState(call, result);
        break;
      case "attachBluetoothListener" :
        attachBluetoothListener(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
