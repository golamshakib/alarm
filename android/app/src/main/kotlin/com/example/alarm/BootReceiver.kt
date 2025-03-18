package com.example.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.view.FlutterMain

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            Log.d("BootReceiver", "Device Booted, Triggering Flutter Method...")

            // Initialize the Flutter Engine
            FlutterMain.startInitialization(context)
            val flutterEngine = FlutterEngine(context)

            // Start the Flutter engine
            flutterEngine.startInitialization(context)

            // Call method on FlutterEngine
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "alarm_channel")
                .invokeMethod("handleAlarmOnAppStart", null)
        }
    }
}
