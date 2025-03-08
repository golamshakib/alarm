
import 'package:alarm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import 'core/utils/constants/app_sizes.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.init,
      getPages: AppRoute.routes,
      initialBinding: ControllerBinder(),
      themeMode: ThemeMode.light,
      // theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
    );
  }
}
