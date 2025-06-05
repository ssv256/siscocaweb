import 'package:domain/models/passport/passport.dart';
import 'package:siscoca/app/data/services/medical_passport/medical_passport_service.dart';

class MedicalPassportRepositoryWeb {
  final MedicalPassportService _service;

  MedicalPassportRepositoryWeb(this._service);

  Future<MedicalPassport> getMedicalPassport(String patientId) async {
    try {
      return await _service.getMedicalPassport(patientId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createMedicalPassport(MedicalPassport medicalPassport) async {
    try {
      return await _service.createMedicalPassport(medicalPassport);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateMedicalPassport(MedicalPassport medicalPassport) async {
    try {
      return await _service.updateMedicalPassport(medicalPassport);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMedicalPassport(String id) async {
    try {
      await _service.deleteMedicalPassport(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProcedure(String procedureId) async {
    try {
      await _service.deleteProcedure(procedureId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteResidualLesion(String lesionId) async {
    try {
      await _service.deleteResidualLesion(lesionId);
    } catch (e) {
      rethrow;
    }
  }
}
