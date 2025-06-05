import 'dart:ui';
import 'package:api/api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:provider/provider.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/modules/auth/auth_login/controllers/auth_controller.dart';
import 'package:siscoca/firebase_options.dart';
import 'package:siscoca/routes/navigation_service.dart';
import 'package:toastification/toastification.dart';
import 'package:url_strategy/url_strategy.dart';
import 'core/utils/dependencies.dart';
import 'core/theme/theme.dart';
import 'routes/pages.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.testMode = true;
  
  final brain = Brain();
  final tokenStorage = InMemoryTokenStorage();
  Get.put<Brain>(brain, permanent: true);
  Get.put<TokenStorage>(tokenStorage, permanent: true);
  DependencyInjection.init();

  final authController = AuthController(tokenStorage: tokenStorage);
  Get.put(authController, permanent: true);
  Health().configure();
  
  DependencyInjection.init();
  
  CococareApiClient.initialize(
    environment: ApiEnvironment.pro,
    tokenProvider: tokenStorage,
  );

//   Map<String, Function> registry = FromJsonFactory().getRegistry();
//   registry.forEach((key, value) {
//     print('Type: $key, Function: $value');
//   });
// //carp_Serializable
//   Map<String, Function> getRegistry() {
//     return Map.from(_registry);
//   }
  
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorNotifier(),
      child: Consumer<ColorNotifier>(
        builder: (context, colorNotifier, _) {
          return ToastificationWrapper(
            child: GetMaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: View.of(context).platformDispatcher.locale,
              fallbackLocale: const Locale('es'),
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.mouse},
              ),
              theme: colorNotifier.getTheme(context),
              transitionDuration: const Duration(milliseconds: 200),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.auth,
              getPages: AppPages.pages,
              routingCallback: (routing) async {
                if (routing == null) return;
                
                final brain = Get.find<Brain>();
                final navigationService = NavigationService();
                
                // Wrap navigation logic in Future.microtask to avoid build-time navigation
                Future.microtask(() async {
                  try {
                    // If user is not logged in and trying to access protected route
                    if (!brain.isLoggedIn && 
                        routing.current != AppRoutes.auth) {
                      await navigationService.safeNavigate(
                        AppRoutes.auth,
                        offAll: true,
                      );
                    }
                  } catch (e) {
                    debugPrint('Routing callback error: $e');
                  }
                });
              }
            ),
          );
        },
      ),
    );
  }
}