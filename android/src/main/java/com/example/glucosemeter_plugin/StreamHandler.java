package com.example.glucosemeter_plugin;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.os.Handler;
import android.util.Log;

import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseBean;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseBluetoothUtil;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseDeviceBean;
import com.hzkj.bw.bloodglucoselibrary.BloodGlucoseErBean;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import io.flutter.plugin.common.EventChannel;

class BluetoothListenerStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink eventSink;
    private Handler handler;

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

    public BluetoothListenerStreamHandler(BloodGlucoseBluetoothUtil bloodGlucoseBluetoothUtil){
        this.bloodGlucoseBluetoothUtil = bloodGlucoseBluetoothUtil;
    }

    private Runnable runnable = () -> {
        attachListener();
    };

    private void attachListener(){
        bloodGlucoseBluetoothUtil.setBloodBluetoothListener(new BloodGlucoseBluetoothUtil.OnBloodBluetoothListener() {
            @Override
            public void onSearchStarted() {
                Log.i("GLUCOSEMETER:INFO", "onSearchStarted runned");
                postResult("onSearchStarted started");
            }

            @Override
            public void onSearchStopped() {
                Log.i("GLUCOSEMETER:INFO", "onSearchStopped runned");
                postResult("search stopped");
            }

            @Override
            public void onDeviceSpyListener(BluetoothDevice bluetoothDevice, Integer integer) {
                Log.i("GLUCOSEMETER:INFO", "onDeviceSpyListener runned");
                Log.i("GLUCOSEMETER:INFO", bluetoothDevice.getName());
                if(deviceList.contains(bluetoothDevice.getName())){
                    bloodGlucoseBluetoothUtil.connectBluetooth(bluetoothDevice);
                    postResult("connecting bluetooth");
                }
            }

            @Override
            public void onDeviceBreakListener() {
                Log.i("GLUCOSEMETER:INFO", "onDeviceBreakListener runned");
                postResult("onDeviceBreakListener runned");
            }

            @Override
            public void onDeviceConnectSucceed() {
                Log.i("GLUCOSEMETER:INFO", "onDeviceConnectSucceed runned");
                postResult("device connected");
            }

            @Override
            public void onConcentrationResultListener(BloodGlucoseBean bloodGlucoseBean) {
                HashMap<String, String> resultMap = new HashMap<>();
                resultMap.put("concentration", bloodGlucoseBean.getConcentration());
                resultMap.put("timeStamp", bloodGlucoseBean.getTimestamp());

                Log.i("GLUCOSEMETER:INFO", "onConcentrationResultListener runned: " + bloodGlucoseBean.toString());
                postResult(resultMap.toString());
            }

            @Override
            public void onTestPaperResultListener() {
                Log.i("GLUCOSEMETER:INFO", "onTestPaperResultListener runned");
                postResult("onTestPaperResultListener runned");
            }

            @Override
            public void onBleedResultListener() {
                Log.i("GLUCOSEMETER:INFO", "onBleedResultListener runned");
                postResult("onBleedResultListener runned");
            }

            @Override
            public void onDownTimeResultListener(int i) {
                Log.i("GLUCOSEMETER:INFO", "onDownTimeResultListener runned");
                postResult("onDownTimeResultListener runned");
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
                postResult("onErTypeResultListener" + message);
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
                postResult("onMemorySynListener" + data);
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
                postResult(String.valueOf(data));
            }

            @Override
            public void onReadBluetoothRssi(Integer integer) {
                Log.i("GLUCOSEMETER:INFO", "onReadBluetoothRssi runned: " + integer.toString());
                postResult("onReadBluetoothRssi: " + integer);
            }

            @Override
            public void onDeviceConnectFailing(int i) {
                Log.i("GLUCOSEMETER:INFO", "onDeviceConnectFailing runned: " + i);
                postResult("onDeviceConnectFailing: " + i);
            }
        });
    }

    private void postResult(String message){
        eventSink.success(message);
        handler.postDelayed(runnable, 1000);
    }

    // Method for testing streaming data from Java
    private void generateRandomNumber(){
        int randomNumber = new Random().nextInt(9);
        eventSink.success(Integer.toString(randomNumber));
        handler.postDelayed(runnable, 1000);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        handler = new Handler();
        handler.post(runnable);
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
        handler.removeCallbacks(runnable);
    }
}