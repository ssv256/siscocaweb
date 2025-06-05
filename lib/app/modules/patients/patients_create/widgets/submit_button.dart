import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';

class FormSubmitButton extends StatelessWidget {
  /// The form key used for validation
  final GlobalKey<FormState> formKey;
  
  /// The callback function to execute when the form is valid
  final Future<void> Function() onSubmit;
  
  /// Optional callback for showing error messages
  final void Function(String)? onError;
  
  /// Optional custom button text
  final String buttonText;

  const FormSubmitButton({
    super.key,
    required this.formKey,
    required this.onSubmit,
    this.onError,
    this.buttonText = 'Continuar',
  });

  /// Default error handling method if none provided
  void _defaultErrorHandler(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EdButton(
      width: double.infinity,
      textColor: Colors.white,
      bgColor: Theme.of(context).primaryColor,
      text: buttonText,
      onTap: () async {
        if (formKey.currentState!.validate()) {
          try {
            await onSubmit();
          } catch (e) {
            final errorHandler = onError ?? _defaultErrorHandler;
            errorHandler('Error al procesar el formulario: $e');
          }
        }
      },
    );
  }
}