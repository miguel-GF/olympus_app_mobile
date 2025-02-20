import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '/app_assets.dart';
import '/controllers/session_controller.dart';
import '/controllers/usuario_controller.dart';
import '/models/usuario.dart';
import '/routes/routes_names.dart';
import '/utils/dialog_util.dart';
import '/utils/exception_util.dart';
import '/widgets/gb_button.dart';
import '/widgets/gb_label_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _obscureText = true;
  final TextEditingController usuarioTextCtr = TextEditingController();
  final TextEditingController passwordTextCtr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usuarioTextCtr.dispose();
    passwordTextCtr.dispose();
    super.dispose();
  }

  Future<void> _irHome() async {
    try {
      FocusScope.of(Get.context!).unfocus();
      setState(() {
        _isLoading = true;
      });
      if (formKey.currentState?.validate() ?? false) {
        final String usuario = usuarioTextCtr.text.trim();
        final String password = passwordTextCtr.text.trim();
        // ignore: always_specify_types
        await Future.delayed(const Duration(milliseconds: 500));
        final UsuarioController usuarioController =
            Get.find<UsuarioController>();
        final List<Usuario> usuarios = await usuarioController.buscar(
          usuario: usuario,
          password: password,
        );
        if (usuarios.isEmpty) {
          DialogUtil.showCustomBottomSheet(
            context: Get.context!,
            content: SizedBox(
              width: 300,
              height: 300,
              child: AspectRatio(
                aspectRatio: 1,
                child: EmptyWidget(
                  packageImage: PackageImage.Image_4,
                ),
              ),
            ),
            title: 'Usuario no encontrado',
          );
        } else {
          final SessionController sessionController =
              Get.find<SessionController>();
          await sessionController.saveSession(usuarios[0]);
          Get.offAndToNamed(nameTabsScreen);
        }
      }
    } on ConnectionException catch (e) {
      _showErrorDialog(
        e.message,
        Lottie.asset(
          AppAssets.wifiAnimation,
          fit: BoxFit.contain,
        ),
        0.75,
      );
    } on AuthenticationException catch (e) {
      _showErrorDialog(
        e.message,
        const Icon(
          Icons.error_outline_rounded,
          size: 100,
          color: Color.fromRGBO(180, 38, 2, 1),
        ),
        0.5,
      );
    } on DatabaseException catch (e) {
      _showErrorDialog(
        e.toString().replaceFirst('Exception: ', ''),
        const Icon(
          Icons.cloud_off_rounded,
          size: 100,
          color: Color.fromRGBO(180, 38, 2, 1),
        ),
        0.5,
      );
    } catch (e) {
      _showErrorDialog(
        'Ocurrió un error inesperado',
        const Icon(
          Icons.error_outline_rounded,
          size: 100,
          color: Color.fromRGBO(180, 38, 2, 1),
        ),
        0.5,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(
      String message, Widget imageWidget, double? heightFactor) {
    DialogUtil.showCustomBottomSheet(
      context: Get.context!,
      content: Padding(
        padding: const EdgeInsets.all(50),
        child: imageWidget,
      ),
      title: message,
      heightFactor: heightFactor ?? 0.75,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olympus RT'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: Get.width * 0.6,
                      child: Image.asset(
                        AppAssets.logoAppImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Gap(30),
                    const SizedBox(child: GbInputLabel(texto: 'Usuario')),
                    TextFormField(
                      controller: usuarioTextCtr,
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Tu usuario es requerido';
                        }
                        return null;
                      },
                    ),
                    const Gap(30),
                    const GbInputLabel(texto: 'Password'),
                    TextFormField(
                      controller: passwordTextCtr,
                      textInputAction: TextInputAction.done,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Tu password es requerido';
                        }
                        return null;
                      },
                      // onFieldSubmitted: (_) => _irHome(),
                    ),
                    const Gap(30),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child:
                              ScaleTransition(scale: animation, child: child),
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
      ),
    );
  }
}
