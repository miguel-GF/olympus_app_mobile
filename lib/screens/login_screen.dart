import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '/controllers/usuario_controller.dart';
// import '/routes/routes_names.dart';
import '/widgets/gb_button.dart';
import '/widgets/gb_label_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  Future<void> _irHome() async {
    // Get.offAndToNamed(nameTabsScreen);
    try {
      setState(() {
        _isLoading = true;
      });
      // ignore: always_specify_types
      await Future.delayed(const Duration(seconds: 1));
      final UsuarioController usuarioController = Get.find<UsuarioController>();
      await usuarioController.buscar(
        usuario: 'demo@gmail.com',
        password: '1234',
      );
      await usuarioController.listar();
    } catch (e) {
      print('desde login');
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olympus'),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(child: GbInputLabel(texto: 'Usuario')),
                  TextFormField(),
                  const MaxGap(30),
                  const GbInputLabel(texto: 'Password'),
                  TextFormField(),
                  const MaxGap(30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: !_isLoading
                        ? GbButton(
                            texto: 'Login',
                            onPressed: _irHome,
                          )
                        : LoadingAnimationWidget.dotsTriangle(
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
