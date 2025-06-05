import 'package:domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

/// Extension that handles patient personal information form functionality
extension PatientUserFormExtension on PatientsCreateController {

  void initializeControllers() {
    // Dispose existing controllers if they exist to prevent memory leaks
    try {
      nameController.dispose();
      lastNameController.dispose();
      patientNumberController.dispose();
      emailController.dispose();
    } catch (e) {
      // Controllers not initialized yet, ignore
    }
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    patientNumberController = TextEditingController();
    emailController = TextEditingController();
  }

  void updateGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
      genderError.value = false;
    }
  }

  bool validatePatientForm() {
    if (!patientFormKey.currentState!.validate()) return false;
    if (selectedGender.value.isEmpty) {
      genderError.value = true;
      return false;
    }
    return true;
  }

  /// Save patient form data
  Future<User> savePatient() async {
    User newUser = const User();
    try {
      final userData = User(
        id: patient.value?.id,
        name: nameController.text,
        surname: lastNameController.text,
        sex: selectedGender.value,
        birthDate: birthDateController.text,
        patientNumber: patientNumberController.text,
        email: emailController.text,
      );
      if(isEdit){
        newUser = await patientRepository.updatePatient(userData);
      }else{
        newUser = await patientRepository.createPatient(userData);
      }
      return newUser;
    } catch (e) {
      throw Exception('Failed to create user patient: $e');
    }
  }

  String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha de nacimiento es requerida';
    }

    // Check format matches dd/MM/yyyy
    RegExp dateFormat = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateFormat.hasMatch(value)) {
      return 'Formato inválido. Use dd/MM/yyyy';
    }

    try {
      List<String> parts = value.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      
      DateTime date = DateTime(year, month, day);
      if (date.isAfter(DateTime.now())) {
        return 'La fecha no puede ser futura';
      }
      
      // Check reasonable year range (e.g., last 120 years)
      int currentYear = DateTime.now().year;
      if (year < currentYear - 100 || year > currentYear) {
        return 'Año fuera de rango válido';
      }
      
      // Verify the parsed date matches input
      // This catches invalid dates like 31/04/2023 (April has 30 days)
      if (date.day != day || date.month != month || date.year != year) {
        return 'Fecha inválida';
      }
      
      return null;
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  void disposePatientForm() {
    nameController.dispose();
    lastNameController.dispose();
    patientNumberController.dispose();
    emailController.dispose();
    birthDateController.dispose();
  }
}