import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/controllers/session_controller.dart';
import '/widgets/gb_button.dart';
import '/widgets/profile/usuario_info_sesion_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> cerrarSesion() async {
    final SessionController sessionController = Get.find<SessionController>();
    await sessionController.clearSession();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                        ), // Ícono a la derecha
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  const Gap(20),
                  const UsuarioInfoSesionWidget(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20.0),
          child: GbButton(
            accion: 'secundaria',
            texto: 'Cerrar sesión',
            onPressed: cerrarSesion,
          ),
        ),
      ),
    );
  }
}
