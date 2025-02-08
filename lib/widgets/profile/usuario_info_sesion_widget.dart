import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../controllers/session_controller.dart';

class UsuarioInfoSesionWidget extends StatelessWidget {
  const UsuarioInfoSesionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Get.find<SessionController>();
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircleAvatar(
            maxRadius: 60,
            child: Icon(
              Icons.person_outline_rounded,
              size: 60,
            ),
          ),
          const Gap(20),
          Text(
            sessionController.usuario.nombre,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            sessionController.usuario.correo,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(10),
          AutoSizeText(
            sessionController.usuario.empresa,
            style: Theme.of(context).textTheme.headlineSmall,
            maxLines: 2,
            minFontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
