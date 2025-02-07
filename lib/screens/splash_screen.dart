import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '/app_assets.dart';
import '/controllers/session_controller.dart';
import '/routes/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SessionController sessionController = Get.find<SessionController>();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await  Future<dynamic>.delayed(const Duration(milliseconds: 1500));
    final bool isValid = await sessionController.isTokenValid();

    if (isValid) {
      Get.offAndToNamed(nameTabsScreen);
    } else {
      Get.offAndToNamed(nameLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(AppAssets.loadingAnimation, fit: BoxFit.contain),
      ), // Pantalla de carga mientras se verifica la sesión
    );
  }
}
