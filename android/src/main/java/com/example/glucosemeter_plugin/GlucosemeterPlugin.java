package com.example.glucosemeter_plugin;

import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
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
import java.util.ArrayList;
import java.util.Arrays;
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

  private EventChannel eventChannel;

  private Activity activity;
  private Context context;
  private BloodGlucoseBluetoothUtil bloodGlucoseBluetoothUtil;

  private List<String> deviceList = Arrays.asList(
    "BG-211b",
    "BG-207b",
    "BG-208b",
    "BG-209b",
    "BG-707b",
    "BG-709b",
    "BG-210b",
    "BG-710b",
    "BG-211b",
    "BG-212b",
    "BG-712b"
  );

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

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    bloodGlucoseBluetoothUtil = new BloodGlucoseBluetoothUtil(context);
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "glucosemeter_plugin");
    channel.setMethodCallHandler(this);
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "glucosemeter_plugin_event");
    eventChannel.setStreamHandler(new BluetoothListenerStreamHandler(bloodGlucoseBluetoothUtil));
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
