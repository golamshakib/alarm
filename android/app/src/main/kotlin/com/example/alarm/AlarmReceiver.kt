package com.example.alarm


import android.R
import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build

import android.widget.Toast
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context.VIBRATOR_SERVICE
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.TaskStackBuilder

class AlarmReceiver : BroadcastReceiver() {
    private val CHANNEL_ID = "alarm_channel_id"

    override fun onReceive(context: Context, intent: Intent) {
        // Play sound and vibration
        playAlarmSound(context)
        vibratePhone(context)

        // Show the notification with buttons
        showNotification(context)
    }

    private fun playAlarmSound(context: Context) {
        try {
            val ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            val ringtone = RingtoneManager.getRingtone(context, ringtoneUri)
            ringtone.play()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun vibratePhone(context: Context) {
        val vibrator: Vibrator? = context.getSystemService(VIBRATOR_SERVICE) as? Vibrator
        if (vibrator != null && vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(0, 1000, 1000), -1))
            } else {
                vibrator.vibrate(longArrayOf(0, 1000, 1000), -1)
            }
        }
    }

    @SuppressLint("MissingPermission")
    private fun showNotification(context: Context) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Create a notification channel for Android 8.0 and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, "Alarm Channel", NotificationManager.IMPORTANCE_HIGH)
            notificationManager.createNotificationChannel(channel)
        }

        // Intent to handle snooze action
        val snoozeIntent = Intent(context, AlarmReceiver::class.java).apply {
            action = "SNOOZE_ALARM"
        }
        val snoozePendingIntent = PendingIntent.getBroadcast(
            context, 0, snoozeIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Intent to handle stop action
        val stopIntent = Intent(context, AlarmReceiver::class.java).apply {
            action = "STOP_ALARM"
        }
        val stopPendingIntent = PendingIntent.getBroadcast(
            context, 1, stopIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Create the notification with two actions
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("Alarm Triggered!")
            .setContentText("Time to wake up!")
            .setSmallIcon(R.drawable.ic_dialog_alert)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .addAction(R.drawable.ic_menu_add, "Snooze", snoozePendingIntent)
            .addAction(R.drawable.ic_delete, "Stop", stopPendingIntent)
            .setAutoCancel(true)
            .build()

        // Show the notification
        NotificationManagerCompat.from(context).notify(0, notification)
    }
}
