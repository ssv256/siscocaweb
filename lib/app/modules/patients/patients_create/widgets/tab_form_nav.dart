import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import 'package:siscoca/app/modules/patients/patients_create/widgets/form_navigation_buttons.dart';

class FormTabItem {
  final String title;
  final int index;
  final bool isRequired;

  const FormTabItem({
    required this.title,
    required this.index,
    this.isRequired = false,
  });
}

/// Widget that handles the form navigation tabs
class TabFormNav extends GetView<PatientsCreateController> {
  const TabFormNav({Key? key}) : super(key: key);

  static const List<FormTabItem> _tabs = [
    FormTabItem(title: 'Nuevo Paciente', index: 0, isRequired: true),
    FormTabItem(title: 'Constantes', index: 1, isRequired: true),
    FormTabItem(title: 'Alertas Personalizadas', index: 2),
    FormTabItem(title: 'Patología', index: 3, isRequired: true),
    FormTabItem(title: 'Información clinica', index: 4, isRequired: true),
    FormTabItem(title: 'Procedimientos', index: 5),
    FormTabItem(title: 'Lesiones Residuales', index: 6),
    FormTabItem(title: 'Medicación', index: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tab list with scrolling if needed
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _tabs.map((tab) => _buildTabItem(tab, context)).toList(),
              ),
            ),
          ),
          // Navigation buttons always visible at bottom
          Obx(() => FormNavigationButtons(
            currentStep: controller.currentFormIndex.value,
            totalSteps: _tabs.length,
            onPrevious: () => controller.currentFormIndex.value--,
            onNext: () => _validateAndContinue(),
            onSave: () => _validateAndSave(),
            disablePrevious: controller.currentFormIndex.value == 0,
            disableNext: false,
          )),
        ],
      ),
    );
  }

  Widget _buildTabItem(FormTabItem tab, BuildContext context) {
    return Obx(() {
      final isCompleted = controller.patient.value != null || controller.completedForms.contains(tab.index);
      final isActive = controller.currentFormIndex.value == tab.index;
      final canNavigate = controller.patient.value != null || controller.canProceedToNext(tab.index);
      final theme = Theme.of(context);
      
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canNavigate ? () => controller.currentFormIndex.value = tab.index : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: isActive ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isActive 
                ? Border.all(color: theme.primaryColor.withOpacity(0.3), width: 1.5)
                : null,
            ),
            child: Row(
              children: [
                _buildTabIndicator(
                  index: tab.index,
                  isCompleted: isCompleted,
                  isActive: isActive,
                  context: context,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTabLabel(
                    title: tab.title,
                    isCompleted: isCompleted, 
                    isActive: isActive,
                    theme: theme,
                    isRequired: tab.isRequired,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabIndicator({
    required int index,
    required bool isCompleted,
    required bool isActive,
    required BuildContext context,
  }) {
    final color = _getIndicatorColor(
      isCompleted: isCompleted,
      isActive: isActive,
      context: context,
    );
    
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isActive || isCompleted 
          ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ]
          : null,
      ),
      child: Center(
        child: isCompleted 
          ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 16,
            )
          : Text(
              '${index + 1}',
              style: TextStyle(
                color: isCompleted || isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
      ),
    );
  }

  Widget _buildTabLabel({
    required String title,
    required bool isCompleted,
    required bool isActive,
    required ThemeData theme,
    bool isRequired = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isCompleted 
                ? Colors.green.shade700
                : isActive 
                  ? theme.primaryColor
                  : Colors.grey.shade700,
              fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isRequired)
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
      ],
    );
  }

  Color _getIndicatorColor({
    required bool isCompleted,
    required bool isActive,
    required BuildContext context,
  }) {
    if (isCompleted) return Colors.green;
    if (isActive) return Theme.of(context).primaryColor;
    return Theme.of(context).primaryColorLight;
  }

  void _validateAndContinue() {
    controller.validateAndContinue();
  }

  void _validateAndSave() async {
    if (controller.validateCurrentForm()) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      try {
        await controller.save();
      } finally {
        // Close the loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    }
  }
} 