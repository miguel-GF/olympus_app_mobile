import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

import '/app_assets.dart';
import '/controllers/session_controller.dart';
import '/routes/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  final SessionController sessionController = Get.find<SessionController>();
  bool _hasNavigated = false; // Para evitar múltiples llamadas

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(AppAssets.splashVideo)
      ..initialize().then((_) {
        setState(() {});
        _controller.setPlaybackSpeed(0.8);
        _controller.play();
        _controller.setVolume(0);
      });

    _controller.addListener(() async {
      if (!_hasNavigated &&
          _controller.value.position >= _controller.value.duration) {
        _hasNavigated = true; // Marcar que ya navegamos
        await Future<dynamic>.delayed(const Duration(milliseconds: 250));

        final bool isValid = await sessionController.isTokenValid();
        if (isValid) {
          Get.offAndToNamed(nameTabsScreen);
        } else {
          Get.offAndToNamed(nameLoginScreen);
        }
      }
    });
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: _controller.value.isInitialized
                ? SizedBox(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : LoadingAnimationWidget.dotsTriangle(
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
          ),
        ),
      ),
    );
  }
}
