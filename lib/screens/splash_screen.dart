import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app_assets.dart';
import '/controllers/session_controller.dart';
import '/routes/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SessionController sessionController = Get.find<SessionController>();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configurar el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Hace que la animación se repita en reversa

    // Crear una animación de opacidad de 0.3 a 1.0
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
    final bool isValid = await sessionController.isTokenValid();

    if (isValid) {
      Get.offAndToNamed(nameTabsScreen);
    } else {
      Get.offAndToNamed(nameLoginScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            AppAssets.logoEmpresaImage,
            width: Get.width * 0.35,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
