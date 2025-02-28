import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'controllers/main_controller.dart';
import 'routes/routes_names.dart';
import 'routes/routes_pages.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  await dotenv.load();
  await initializeDateFormatting();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Intl.defaultLocale = 'es_MX';
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
      defaultTransition: Transition.rightToLeftWithFade,
      initialRoute: nameSplashScreen,
    );
  }
}
