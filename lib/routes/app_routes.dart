import 'package:get/get.dart';

import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/splash_screen/presentation/screens/splash_screen.dart';

class AppRoute {
  static String init = "/";
  static String loginScreen = "/loginScreen";


  static List<GetPage> routes = [
    GetPage(name: init, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
  ];
}