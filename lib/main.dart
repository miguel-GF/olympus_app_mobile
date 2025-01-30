import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/main_controller.dart';
import 'routes/routes_pages.dart';
import 'screens/login_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    return GetMaterialApp(
      title: 'Olympus App Mobile',
      theme: themeLight,
      getPages: rutas,
      defaultTransition: Transition.leftToRightWithFade,
      home: const LoginScreen(),
    );
  }
}
