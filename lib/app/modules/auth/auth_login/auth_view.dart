import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/routes/routes.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/buttons/ed_button.dart';
import '../../../widgets/inputs/main_input.dart';
import 'controllers/auth_controller.dart';

class AuthView extends StatelessWidget {
  AuthView({super.key}) {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(tokenStorage: Get.find()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthViewHelper>(
        init: AuthViewHelper(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight
                ),
                child: controller.content(context)
              )
            );
          }
        )
      )
    );
  }
}

class AuthViewHelper extends GetxController {
  final formKeyAuth = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final isLoading = false.obs;
  final rememberSession = false.obs;

  AuthController get authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    try {
      // Check if controllers are still valid before disposing
      if (!GetInstance().isRegistered<AuthViewHelper>()) {
        emailController.dispose();
        passwordController.dispose();
      }
    } catch (e) {
      print('Error disposing controllers: $e');
    }
    super.onClose();
  }

  Widget content(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        form(context),
        if (MediaQuery.of(context).size.width >= 1024) 
          image(context)
      ]
    );
  }

  Widget form(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: formKeyAuth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', height: 80),
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.signInToWorkspace,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                const SizedBox(height: 15),
                // Text(
                //   l10n.loginDescription,
                //   style: Theme.of(context).textTheme.bodySmall,
                //   textAlign: TextAlign.start
                // ),
                TextFieldWidget(
                  controller: emailController,
                  title: l10n.emailLabel,
                  required: true,
                ),
                TextFieldWidget(
                  controller: passwordController,
                  title: l10n.passwordLabel,
                  required: true,
                  obscureText: true,
                ),
                // rememberSessionCheckbox(context),
                const SizedBox(height: 20),
                loginButton(context),
                const SizedBox(height: 15),
                resetPasswordButton(context),
                const SizedBox(height: 15),
              ]
            )
          )
        ),
      )
    );
  }

  Widget rememberSessionCheckbox(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () => rememberSession.value = !rememberSession.value,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: rememberSession.value 
                    ? Theme.of(context).primaryColor 
                    : Colors.transparent,
                border: Border.all(
                  color: const Color.fromARGB(216, 52, 52, 52)
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: rememberSession.value 
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.rememberSession,
              style: Theme.of(context).textTheme.bodyLarge
            )
          ],
        ),
      ),
    ));
  }

  Widget loginButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() => EdButton(
      width: double.infinity,
      height: 60,
      borderRadius: 10,
      textColor: Colors.white,
      bgColor: Theme.of(context).primaryColor,
      isLoader: isLoading.value,
      text: l10n.signInButton,
      onTap: () => _handleLogin(context)
    ));
  }

  Widget resetPasswordButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EdButton(
      width: double.infinity,
      height: 60,
      borderRadius: 10,
      textColor: Colors.black,
      bgColor: Colors.white,
      text: l10n.resetPasswordButton,
      onTap: () => Get.toNamed(AppRoutes.authLostAccount)
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    // Validate form if available
    if (formKeyAuth.currentState != null && !formKeyAuth.currentState!.validate()) {
      return;
    }

    // final email = emailController.text.trim();
    // final password = passwordController.text;
    
    // Uncomment for testing with hardcoded values
    const email = 'albertoluna92@gmail.com';
    const password = 'qwe123asd';

    if (!GetUtils.isEmail(email)) {
      toastification.show(
        context: context,
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text(l10n.invalidEmail),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
      return;
    }

    if (password.length < 6) {
      toastification.show(
        context: context,
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text(l10n.passwordMinLength),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
      return;
    }

    isLoading.value = true;
    try {
      await authController.login(email, password);
    } catch (e) {
      toastification.show(
        context: context,
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text(e.toString()),
        autoCloseDuration: const Duration(seconds: 4),
        style: ToastificationStyle.flat,
      );
      isLoading.value = false;
    }
  }

  Widget image(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/auth.jpg'),
            fit: BoxFit.cover
          )
        )
      ),
    );
  }
}