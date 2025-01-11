import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/Auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(const MyApp());
}
