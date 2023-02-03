package com.example.glucosemeter_plugin;
import android.os.Handler;

import java.util.Random;

import io.flutter.plugin.common.EventChannel;

class BluetoothListenerStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink eventSink;
    private Handler handler;

    private Runnable runnable = () -> {
        generateRandomNumber();
    };

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