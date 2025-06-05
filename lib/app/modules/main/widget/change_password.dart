import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/main/controller/main_controller.dart';
import 'package:siscoca/app/widgets/inputs/simple_textfield.dart';
import 'package:siscoca/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatelessWidget {
  final double width;
  final ColorNotifier notifire;
  final MainController controller;

  const ChangePassword({
    super.key,
    required this.width,
    required this.notifire,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.cardTheme.shadowColor ?? Colors.transparent,
            blurRadius: notifire.getIsDark ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.changePassword,
            style: TextStyle(
              fontSize: 25,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            l10n.changePasswordDescription,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          SimpleTextField(
            title: l10n.oldPassword,
            hintText: l10n.oldPasswordHint,
            controller: controller.oldPasswordController,
            isPassword: true,
          ),
          const SizedBox(height: 15),
          SimpleTextField(
            title: l10n.newPassword,
            hintText: l10n.newPasswordHint,
            controller: controller.newPasswordController,
            isPassword: true,
          ),
          const SizedBox(height: 15),
          SimpleTextField(
            title: l10n.newPasswordConfirmation,
            hintText: l10n.confirmPasswordHint,
            controller: controller.confirmPasswordController,
            isPassword: true,
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: controller.isLoading.value ? null : controller.changePassword,
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: controller.isLoading.value 
                  ? theme.colorScheme.primary.withOpacity(0.5)
                  : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    l10n.changePassword,
                    style: const TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    ));
  }
}