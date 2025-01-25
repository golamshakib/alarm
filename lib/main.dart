import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/Auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter engine
  await AuthService.init();
  runApp(const MyApp());
}
