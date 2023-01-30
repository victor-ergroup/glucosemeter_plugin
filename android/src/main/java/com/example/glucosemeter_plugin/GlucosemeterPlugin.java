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
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseBean;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseBluetoothUtil;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseDeviceBean;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseErBean;

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
