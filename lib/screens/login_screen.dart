import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/routes/routes_names.dart';
import '/widgets/gb_button.dart';
import '/widgets/gb_label_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _irHome() {
    Get.offAndToNamed(nameTabsScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  GbButton(
                    texto: 'Login',
                    onPressed: _irHome,
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
