import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/auth/auth_login/controllers/auth_controller.dart';
import '../../../widgets/buttons/ed_button.dart';

class LostAccountView extends GetView<AuthController> {
  const LostAccountView({super.key});

  Widget content(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        form(context),
        if (GetPlatform.isDesktop) image(context),
      ],
    );
  }

  Widget form(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', height: 80),
                const SizedBox(height: 15),
                _buildPasswordResetForm(),
                const SizedBox(height: 15),
                EdButton(
                  width: double.infinity,
                  height: 60,
                  textColor: Colors.black,
                  bgColor: Colors.white,
                  text: 'Volver a iniciar sesión',
                  onTap: () => Get.offNamed('/auth'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordResetForm() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recuperar contraseña',
            style: Get.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa tu correo electrónico y te enviaremos las instrucciones para restablecer tu contraseña.',
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo electrónico';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Por favor ingresa un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          EdButton(
            width: double.infinity,
            height: 50,
            text: 'Enviar instrucciones',
            onTap: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await controller.forgotPassword(emailController.text);
                  Get.snackbar(
                    'Éxito',
                    'Se han enviado las instrucciones a tu correo electrónico',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'No se pudo enviar el correo de recuperación',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget image(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/auth.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: content(context),
            ),
          );
        },
      ),
    );
  }
}