package com.example.glucosemeter_plugin;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

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
  private Context context;
  private BloodGlucoseBluetoothUtil bloodGlucoseBluetoothUtil;

  public void initGlucoseBluetoothUtil(@NonNull MethodCall call, @NonNull Result result){
    bloodGlucoseBluetoothUtil = new BloodGlucoseBluetoothUtil(context);
    result.success(null);
  }

  public void openBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try{
      bloodGlucoseBluetoothUtil.openBluetooth();
      result.success(null);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void closeBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.closeBluetooth();
      result.success(null);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void scanBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.scanBluetooth();
      result.success(null);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void stopScan(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.stopBluetooth();
      result.success(null);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectBluetooth(@NonNull MethodCall call, @NonNull Result result){
    try {
      BluetoothDevice bluetoothDevice = call.argument("bluetoothDevice");
      bloodGlucoseBluetoothUtil.connectBluetooth(bluetoothDevice);
      result.success(null);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectedDeviceName(@NonNull MethodCall call, @NonNull Result result){
    try {
      String deviceName = bloodGlucoseBluetoothUtil.connectBluetoothDeviceName();
      result.success(deviceName);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectedBluetoothDeviceAddress(@NonNull MethodCall call, @NonNull Result result){
    try {
      String deviceAddress = bloodGlucoseBluetoothUtil.connectBluetoothDeviceAddress();
      result.success(deviceAddress);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void connectedBluetoothDeviceRssi(@NonNull MethodCall call, @NonNull Result result){
    try {
      bloodGlucoseBluetoothUtil.connectBluetoothRssi();
      result.success(null);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }




  public void bluetoothState(@NonNull MethodCall call, @NonNull Result result){
    try {
      boolean state = bloodGlucoseBluetoothUtil.stateBluetooth();
      result.success(state);
    }catch (NullPointerException nullPointerException){
      Log.e("GLUCOSEMETERPLUGIN", "NullPointerException. Have you called initGlucoseBluetoothUtil()?");
      result.error("NullPointerException", nullPointerException.getMessage(), nullPointerException.getCause());
    }catch (Exception e){
      Log.e("GLUCOSEMETERPLUGIN", e.getMessage());
      result.error("ERROR", e.getMessage(), e.getCause());
    }
  }

  public void attachBluetoothListener(@NonNull MethodCall call, @NonNull Result result){
    bloodGlucoseBluetoothUtil.setBloodBluetoothListener(new BloodGlucoseBluetoothUtil.OnBloodBluetoothListener() {
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
        result.success(resultMap);
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
        Log.i("GLUCOSEMETER:INFO", "onErTypeResultListener runned: " + s);
        result.success(s);
      }

      @Override
      public void onMemorySynListener(List<BloodGlucoseBean> list) {
        Log.i("GLUCOSEMETER:INFO", "onMemorySynListener runned: " + list.toString());
      }

      @Override
      public void onDeviceResultListener(BloodGlucoseDeviceBean bloodGlucoseDeviceBean) {
        Log.i("GLUCOSEMETER:INFO", "onDeviceResultListener runned: " + bloodGlucoseDeviceBean.toString());
      }

      @Override
      public void onReadBluetoothRssi(Integer integer) {
        Log.i("GLUCOSEMETER:INFO", "onReadBluetoothRssi runned: " + integer.toString());
      }

      @Override
      public void onDeviceConnectFailing(int i) {
        Log.i("GLUCOSEMETER:INFO", "onDeviceConnectFailing runned: " + i);
      }
    });
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "glucosemeter_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "getPlatformVersion" :
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "initGlucoseBluetoothUtil" :
        initGlucoseBluetoothUtil(call, result);
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
