import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/modules/main/widget/account_settings.dart';
import 'package:siscoca/app/modules/main/widget/change_password.dart';
import 'package:siscoca/app/modules/main/controller/main_controller.dart';
import 'package:siscoca/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late ColorNotifier notifire;
  final Brain brain = Get.find<Brain>();
  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifier>(context, listen: true);
    final theme = notifire.getTheme(context);
    
    return Theme(
      data: theme,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: notifire.getContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (constraints.maxWidth < 600) ...[
                    profile(constraints.maxWidth),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AccountSettings(
                            width: constraints.maxWidth / 2,
                            notifire: notifire,
                            doctor: brain.doctor,
                            isAdmin: brain.isAdminUser,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: ChangePassword(
                            width: constraints.maxWidth / 2,
                            notifire: notifire,
                            controller: mainController,
                          ),
                        ),
                      ],
                    ),
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              profile(constraints.maxWidth),
                              const SizedBox(height: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AccountSettings(
                                      width: constraints.maxWidth / 2,
                                      notifire: notifire,
                                      doctor: brain.doctor,
                                      isAdmin: brain.isAdminUser,
                                      readOnly: true,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: ChangePassword(
                                      width: constraints.maxWidth / 2,
                                      notifire: notifire,
                                      controller: mainController,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget profile(double width) {
    final theme = Theme.of(context);
    final doctor = brain.doctor;
    final l10n = AppLocalizations.of(context);
    
    if (doctor == null) {
      return const SizedBox(); // Return empty if doctor is null
    }
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.cardTheme.shadowColor ?? Colors.transparent,
            blurRadius: notifire.getIsDark ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned(
                bottom: -30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/docImage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Text(
            '${doctor.name} ${doctor.surname}',
            style: TextStyle(
              fontSize: 20,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            brain.isAdminUser ? l10n.adminDoctor : l10n.doctor,
            style: TextStyle(
              fontSize: 15,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}