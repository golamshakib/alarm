package com.example.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import com.example.alarm.AlarmReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "alarm_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAlarm" -> {
                    val time = call.argument<Long>("time")
                    val alarmId = call.argument<Int>("alarmId")
                    if (time != null && alarmId != null) {
                        setAlarm(time, alarmId)
                        result.success("Alarm set for $time with alarmId $alarmId")
                    } else {
                        result.error("INVALID_ARGUMENT", "Time and alarmId are required", null)
                    }
                }
                "snoozeAlarm" -> {
                    val snoozeTime = call.argument<Long>("time")
                    if (snoozeTime != null) {
                        snoozeAlarm(snoozeTime)
                        result.success("Alarm snoozed for $snoozeTime")
                    } else {
                        result.error("INVALID_ARGUMENT", "Time is required", null)
                    }
                }
                "cancelAlarm" -> {
                    cancelAlarm()
                    result.success("Alarm canceled")
                }
                else -> result.notImplemented()
            }
        }
    }

    // Override getInitialRoute() instead of provideInitialRoute()
    override fun getInitialRoute(): String? {
        val showTrigger = intent.getBooleanExtra("showAlarmTrigger", false)
        val alarmId = intent.getIntExtra("alarmId", -1)
        return if (showTrigger) {
            if (alarmId != -1) "/alarmTrigger?alarmId=$alarmId" else "/alarmTrigger"
        } else {
            super.getInitialRoute()
        }
    }

    // (Optional) If your app might already be running, you can also override onNewIntent:
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        // Optionally: use a MethodChannel to notify Flutter about the intent change
    }


    private fun setAlarm(timeInMillis: Long, alarmId: Int) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, AlarmReceiver::class.java).apply {
            putExtra("alarmId", alarmId)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            this, alarmId, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent)
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent)
        }
    }

    private fun snoozeAlarm(timeInMillis: Long) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val snoozeTime = System.currentTimeMillis() + timeInMillis // Snooze time from current time
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, snoozeTime, pendingIntent)
    }

    private fun cancelAlarm() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        alarmManager.cancel(pendingIntent)
    }
}
