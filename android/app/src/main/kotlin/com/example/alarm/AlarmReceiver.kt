package com.example.alarm

import android.R
import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.Ringtone
import android.media.RingtoneManager
import android.os.Build
import android.widget.Toast
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context.VIBRATOR_SERVICE
import android.os.VibrationEffect
import android.os.Vibrator
import android.app.Notification
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.util.Calendar
import android.util.Log
import android.os.Handler
import android.os.Looper

class AlarmReceiver : BroadcastReceiver() {
    private val CHANNEL_ID = "alarm_channel_id"

    companion object {
        private var ringtone: Ringtone? = null  // Static variable to store ringtone instance
    }

    override fun onReceive(context: Context, intent: Intent) {
        val alarmId = intent.getIntExtra("alarmId", -1)
        val action = intent.action
        val snoozeDuration = intent.getLongExtra("snoozeDuration", 60000L) // Default 60 sec
        val repeatDays = intent.getStringArrayListExtra("repeatDays") ?: emptyList()

        val sharedPreferences =
            context.getSharedPreferences("AlarmPreferences", Context.MODE_PRIVATE)
        val isToggledOn = sharedPreferences.getBoolean("alarm_toggle_$alarmId", true)

        if (!isToggledOn) {
            return  // Don't trigger alarm if toggle is off
        }
        when (action) {
            "SNOOZE_ALARM" -> snoozeAlarm(context, alarmId, snoozeDuration)
            "STOP_ALARM" -> stopAlarm(context)
            else -> {
                vibratePhone(context)
                val alarmIntent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    putExtra("showAlarmTrigger", true)
                    putExtra("alarmId", alarmId)
                }
                context.startActivity(alarmIntent)

                // Call showNotification with snoozeDuration
                showNotification(context, alarmId, snoozeDuration)

                if (repeatDays.isNotEmpty()) {
                    scheduleNextRepeat(context, alarmId, repeatDays)
                }
            }
        }
    }

    private fun scheduleNextRepeat(context: Context, alarmId: Int, repeatDays: List<String>) {
        val now = Calendar.getInstance()
        val nextAlarmTime = Calendar.getInstance()

        for (i in 1..7) { // Check the next 7 days
            nextAlarmTime.add(Calendar.DAY_OF_YEAR, 1)
            val dayOfWeek = nextAlarmTime.get(Calendar.DAY_OF_WEEK)

            val dayNames = listOf("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
            val nextDayName = dayNames[dayOfWeek - 1]

            if (repeatDays.contains(nextDayName)) {
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val intent = Intent(context, AlarmReceiver::class.java).apply {
                    putExtra("alarmId", alarmId)
                    putStringArrayListExtra("repeatDays", ArrayList(repeatDays))
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    alarmId,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        nextAlarmTime.timeInMillis,
                        pendingIntent
                    )
                } else {
                    alarmManager.setExact(
                        AlarmManager.RTC_WAKEUP,
                        nextAlarmTime.timeInMillis,
                        pendingIntent
                    )
                }

                Log.d(
                    "AlarmReceiver",
                    "Next repeating alarm scheduled for $nextDayName at ${nextAlarmTime.time}"
                )
                break
            }
        }
    }


    private fun playAlarmSound(context: Context) {
        try {
            val ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ringtone = RingtoneManager.getRingtone(context, ringtoneUri)
            ringtone?.play()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun vibratePhone(context: Context) {
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        vibrator?.let {
            if (it.hasVibrator()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    it.vibrate(VibrationEffect.createWaveform(longArrayOf(0, 1000, 1000), -1))
                } else {
                    it.vibrate(longArrayOf(0, 1000, 1000), -1)
                }
            }
        }
    }

    // This method now accepts the snooze duration.
    private fun snoozeAlarm(context: Context, alarmId: Int, snoozeDuration: Long = 60000L) {
        stopAlarmSound(context) // Stop alarm sound & vibration

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val snoozeIntent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("alarmId", alarmId)
            putExtra("snoozeDuration", snoozeDuration.toInt())
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context, alarmId, snoozeIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val snoozeTime = System.currentTimeMillis() + snoozeDuration
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, snoozeTime, pendingIntent)
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(0)

        Toast.makeText(
            context,
            "Alarm Snoozed for ${snoozeDuration / 60000} minute(s)",
            Toast.LENGTH_SHORT
        ).show()
        Log.d("AlarmReceiver", "Alarm ID $alarmId snoozed for ${snoozeDuration / 60000} minutes")
    }

    private fun stopAlarm(context: Context) {
        stopAlarmSound(context)
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(0)
        Toast.makeText(context, "Alarm Stopped", Toast.LENGTH_SHORT).show()
    }

    private fun stopAlarmSound(context: Context) {
        ringtone?.stop()
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        vibrator?.cancel()
    }

    @Suppress("MissingPermission")
    private fun showNotification(context: Context, alarmId: Int, snoozeDuration: Long = 60000L) {
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Alarm Channel",
                android.app.NotificationManager.IMPORTANCE_HIGH
            )
            channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            channel.setBypassDnd(true)
            notificationManager.createNotificationChannel(channel)
        }

        // Retrieve Alarm Label from SharedPreferences or Intent
        val sharedPreferences =
            context.getSharedPreferences("AlarmPreferences", Context.MODE_PRIVATE)
        val alarmLabel = sharedPreferences.getString("alarm_label_$alarmId", "Alarm Triggered")

        // 🔹 Ensure label is not null (fallback to default)
        val notificationText = if (!alarmLabel.isNullOrEmpty()) alarmLabel else "Time to wake up"

        // Create an empty pending intent that does nothing when clicked
        val emptyIntent = PendingIntent.getActivity(
            context, 0, Intent(), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val flutterIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("showAlarmTrigger", true)
            putExtra("alarmId", alarmId)
        }
        val fullScreenPendingIntent = PendingIntent.getActivity(
            context, alarmId, flutterIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

//        val snoozeIntent = Intent(context, AlarmReceiver::class.java).apply {
//            action = "SNOOZE_ALARM"
//            putExtra("alarmId", alarmId)
//            putExtra("snoozeDuration", snoozeDuration.toInt()) // Convert Long to Int
//        }
//        val snoozePendingIntent = PendingIntent.getBroadcast(
//            context, alarmId + 1, snoozeIntent,
//            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//        )
//
//        val stopIntent = Intent(context, AlarmReceiver::class.java).apply {
//            action = "STOP_ALARM"
//            putExtra("alarmId", alarmId)
//        }
//        val stopPendingIntent = PendingIntent.getBroadcast(
//            context, alarmId + 2, stopIntent,
//            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//        )

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("Alarm Triggered")
            .setContentText(notificationText)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm) // Android's default alarm icon
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setSound(null)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setAutoCancel(false)
            .setOngoing(false)  // Ensure it doesn't persist
            .setContentIntent(emptyIntent)  // Prevent any action on tap
            .build()

        NotificationManagerCompat.from(context).notify(alarmId, notification)
        // **🔹 Remove notification after 2 seconds**
        Handler(Looper.getMainLooper()).postDelayed({
            notificationManager.cancel(alarmId) // Remove notification from panel
        }, 2000)
    }
}
