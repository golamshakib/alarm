# native_alarm_app

### Native Alarm App with Flutter & Platform Channel Integration

A personalized alarm app built using Flutter, offering users the ability to set alarms with custom music, images, and a detailed alarm screen. The app leverages **Flutter Method Channels** to interact with native Android code for accurate alarm triggering and **Shared Preferences** for persistent local storage. Designed for a smooth and responsive user experience with native-level performance.

---

## 🚀 Features

- **🖼 Custom Alarm Screen**  
  Displays alarm-specific information such as title, time, custom image, and sound.

- **🎵 Music Selection**  
  Users can pick their preferred music from the device to set as their alarm sound.

- **💾 Local Storage with Shared Preferences**  
  Stores alarms, music choices, and preferences locally for persistence across sessions.

- **⚙️ Native Alarm Integration**  
  Uses Flutter's Method Channels to trigger alarms at the native Android level.

- **🔊 Personalized Wake-Up Experience**  
  Custom visuals and sound create a unique and user-friendly wake-up flow.

---

## 📹 Project Demo

- App Demo Video: [Watch here](https://your-video-link.com)

---

## 📦 APK Download

- [Download APK](https://your-apk-link.com)

---

## 🧩 Technical Stack

| Area                     | Implementation                            |
|--------------------------|--------------------------------------------|
| Framework                | Flutter                                    |
| Local Storage            | Shared Preferences                         |
| Native Communication     | Flutter Method Channels (Android only)     |
| Alarm Handling           | Android Alarm Manager & Services           |
| State Management         | GetX                                       |
| Media & File Access      | File Picker / Media access via permissions |

---

## 📂 Directory Structure

```bash
lib/
│
├── main.dart
├── core/
│   └── bindings/
│   └── common/widgets/
│   └── db_helpers/
│   └── models/
│   └── services/
│   └── utils/
├── features/
│   └── splash_screen/
│   └── settings/
│   └── nav_bar/
│   └── add_alarm/
│   └── alarm/
├── routes/
│   └── app_routes.dart
├── app.dart
├── main.dart


```

## ⚙️ Installation & Run Locally
Prerequisites
Flutter SDK (latest stable)

Dart SDK

Android Studio / VS Code

Android device or emulator

Steps

```bash

# Clone the repository
git clone https://github.com/golamshakib/alarm.git

# Navigate to project directory
cd alarm

# Install dependencies
flutter pub get

# Run the app
flutter run

```
