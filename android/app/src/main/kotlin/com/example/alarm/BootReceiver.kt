package com.example.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class BootReceiver : BroadcastReceiver() {

    // Define a method channel name that matches the one used in the Flutter app
    private val CHANNEL = "alarm_channel"

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            Log.d("BootReceiver", "Device Booted, Triggering Flutter Method...")

            // Initialize the Flutter engine
            val flutterEngine = FlutterEngine(context)

            // Run the default entry point for the Flutter engine
//            flutterEngine.dartExecutor.executeDartEntrypoint(
//                flutterEngine.dartExecutor.dartEntrypoint
//            )

            // Call method on FlutterEngine using MethodChannel
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("handleAlarmOnAppStart", null)

            Log.d("BootReceiver", "Flutter Method Invoked Successfully")
        }
    }
}
