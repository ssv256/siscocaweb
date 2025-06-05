import 'package:domain/models/models.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

extension ConstantFormExtension on PatientsCreateController {

  void testLoadConstantsData() {
    weightController.text = "70.5";
    heightController.text = "175";
    bloodPressureController.text = "120/80";
    oxygenController.text = "98";
    heartRateController.text = "72";
  }

  bool validateAndSaveConstants() {
    bool validate = true;
    if (!constantsFormKey.currentState!.validate()) validate = false;
    validate = constantsFormKey.currentState?.validate() ?? false;
    saveConstants();
    return validate;
  }

  Future<void> saveConstants() async {
    try {
      final updated = medicalPassport.value!;
      
      if (updated.patientConstants.isNotEmpty) {
        final existingConstant = updated.patientConstants.first;
        final updatedConstant = PatientConstant(
          bloodPressure: bloodPressureController.text,
          height: double.parse(heightController.text),
          oxygenSaturation: oxygenController.text,
          pulseRate: heartRateController.text,
          uniqueId: existingConstant.uniqueId,
          weight: double.parse(weightController.text),
        );
        
        updated.patientConstants[0] = updatedConstant;
      } else {
        updated.patientConstants.add(PatientConstant(
          bloodPressure: bloodPressureController.text,
          height: double.parse(heightController.text),
          oxygenSaturation: oxygenController.text,
          pulseRate: heartRateController.text,
          uniqueId: null,
          weight: double.parse(weightController.text),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}