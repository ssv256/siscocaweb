import 'package:flutter/material.dart';

enum NavButtonType { previous, next, save }

/// A widget that displays navigation buttons for multi-step forms
/// including previous, next, and save buttons with a progress indicator
class FormNavigationButtons extends StatelessWidget {

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSave;
  final bool disablePrevious;
  final bool disableNext;
  final String? previousLabel;
  final String? nextLabel;
  final String? saveLabel;
  final Color? primaryColor;
  final Color? saveColor;

  const FormNavigationButtons({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onPrevious,
    this.onNext,
    this.onSave,
    this.disablePrevious = false,
    this.disableNext = false,
    this.previousLabel,
    this.nextLabel,
    this.saveLabel,
    this.primaryColor,
    this.saveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFirstStep = currentStep == 0;
    final isLastStep = currentStep == totalSteps - 1;
    final theme = Theme.of(context);
    final Color primaryButtonColor = primaryColor ?? theme.primaryColor;
    final Color saveButtonColor = saveColor ?? Colors.green.shade600;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavButton(
                context: context,
                label: previousLabel ?? 'Anterior',
                icon: Icons.arrow_back_rounded,
                onPressed: (isFirstStep || disablePrevious) ? null : onPrevious,
                buttonType: NavButtonType.previous,
                isDisabled: isFirstStep || disablePrevious,
                primaryColor: primaryButtonColor,
              ),
              const SizedBox(width: 8),
              _buildNavButton(
                context: context,
                label: isLastStep 
                  ? (saveLabel ?? 'Guardar') 
                  : (nextLabel ?? 'Siguiente'),
                icon: isLastStep ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                onPressed: disableNext ? null : (isLastStep ? onSave : onNext),
                buttonType: isLastStep ? NavButtonType.save : NavButtonType.next,
                isDisabled: disableNext,
                primaryColor: primaryButtonColor,
                saveColor: saveButtonColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Form progress indicator
          LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isLastStep ? saveButtonColor : primaryButtonColor,
            ),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required NavButtonType buttonType,
    required bool isDisabled,
    required Color primaryColor,
    Color? saveColor,
  }) {

    Color backgroundColor;
    Color textColor;
    Color? overlayColor;
    
    switch (buttonType) {
      case NavButtonType.previous:
        backgroundColor = Colors.white;
        textColor = isDisabled ? Colors.grey.shade400 : primaryColor;
        overlayColor = primaryColor.withOpacity(0.1);
        break;
      case NavButtonType.next:
        backgroundColor = primaryColor;
        textColor = Colors.white;
        overlayColor = Colors.white.withOpacity(0.2);
        break;
      case NavButtonType.save:
        backgroundColor = saveColor ?? Colors.green.shade600;
        textColor = Colors.white;
        overlayColor = Colors.white.withOpacity(0.2);
        break;
    }
    
    return Expanded(
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        elevation: buttonType == NavButtonType.previous ? 0 : 1,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          splashColor: overlayColor,
          highlightColor: overlayColor.withOpacity(0.3),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              border: buttonType == NavButtonType.previous 
                ? Border.all(color: isDisabled ? Colors.grey.shade300 : primaryColor.withOpacity(0.5), width: 1.5) 
                : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: buttonType == NavButtonType.previous 
                ? MainAxisAlignment.start 
                : MainAxisAlignment.end,
              children: [
                if (buttonType == NavButtonType.previous) ...[
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ] else ...[
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, color: textColor, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
} 