import 'package:domain/models/doctor/doctor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/main/controller/main_controller.dart';
import 'package:siscoca/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettings extends StatelessWidget {
  final double width;
  final ColorNotifier notifire;
  final MainController? controller;
  final Doctor? doctor;
  final bool? isAdmin;
  final bool readOnly;

  const AccountSettings({
    super.key,
    required this.width,
    required this.notifire,
    this.controller,
    this.doctor,
    this.isAdmin,
    this.readOnly = false,
  }) : assert(
          (controller != null) || (doctor != null && isAdmin != null),
          'Either controller or both doctor and isAdmin must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    // Use either direct doctor or controller's doctor
    final doctorData = doctor ?? controller!.doctor;
    final isAdminUser = isAdmin ?? controller!.isAdmin;

    return Container(
      padding: const EdgeInsets.all(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              l10n.accountSettings,
              style: TextStyle(
                fontSize: 25,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              readOnly ? 'Account Information (Read Only)' : l10n.accountSettingsDescription,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          if (readOnly) ...[
            _buildReadOnlyField(theme, l10n.name, doctorData.name),
            const SizedBox(height: 15),
            _buildReadOnlyField(theme, l10n.email, doctorData.email),
            const SizedBox(height: 15),
            _buildReadOnlyField(theme, l10n.surname, doctorData.surname),
            const SizedBox(height: 15),
            _buildReadOnlyField(theme, l10n.job, isAdminUser ? l10n.adminDoctor : l10n.doctor),
          ] else ...[
            // Original editable form fields here
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    title: l10n.name,
                    hintText: doctorData.name,
                    enabled: false,
                    isDisabled: true,
                    controller: null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    title: l10n.email,
                    hintText: doctorData.email,
                    enabled: false,
                    isDisabled: true,
                    controller: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    title: l10n.surname,
                    hintText: doctorData.surname,
                    enabled: false,
                    isDisabled: true,
                    controller: null,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField(
              title: l10n.job,
              hintText: isAdminUser ? l10n.adminDoctor : l10n.doctor,
              enabled: false,
              isDisabled: true,
              controller: null,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              title: l10n.aboutMe,
              hintText: l10n.aboutMeHint,
              maxLine: 7,
              controller: null,
              onChanged: (value) => controller?.study.value = value,
            ),
            _buildSaveButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String title,
    required String hintText,
    bool enabled = true,
    bool isDisabled = false,
    int? maxLine,
    TextEditingController? controller,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 13),
        TextField(
          controller: controller,
          enabled: enabled && !isDisabled,
          onChanged: onChanged,
          maxLines: maxLine,
          decoration: InputDecoration(
            filled: isDisabled,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    if (controller == null) {
      return const SizedBox();
    }
    
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: controller!.isLoading.value ? null : controller!.updateProfile,
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: controller!.isLoading.value 
                  ? theme.colorScheme.primary.withOpacity(0.5)
                  : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: controller!.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    l10n.saveChange,
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