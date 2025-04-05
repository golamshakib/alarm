package com.example.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class BootReceiver : BroadcastReceiver() {
    private val CHANNEL = "alarm_channel"

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            Log.d("BootReceiver", "Device Booted, Triggering Flutter Method...")

            // Initialize the Flutter engine
            val flutterEngine = FlutterEngine(context)
            flutterEngine.lifecycleChannel.appIsResumed()

            // Register plugins
            GeneratedPluginRegistrant.registerWith(flutterEngine)

            // Call method on FlutterEngine using MethodChannel to trigger rescheduling
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("handleAlarmOnBoot", null)

            Log.d("BootReceiver", "Flutter Method Invoked Successfully")
        }
    }
}
