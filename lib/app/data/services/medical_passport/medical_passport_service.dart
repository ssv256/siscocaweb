import 'package:api/api.dart';
import 'package:domain/models/passport/passport.dart';

/// Service class for handling medical passport related operations
/// This service acts as a mediator between the API layer and the domain layer
class MedicalPassportService {
  /// Retrieves a medical passport by patient ID
  /// Throws [MedicalPassportException] if the operation fails
  Future<MedicalPassport> getMedicalPassport(String patientId) async {
    try {
      final (data, error) = await MedicalPassportApi.getMedicalPassport(patientId);
      if (error.isNotEmpty) {
        throw MedicalPassportException('Failed to fetch medical passport: $error');
      }
      return MedicalPassport.fromJson(data!);
    } catch (e) {
      throw MedicalPassportException('Error fetching medical passport: $e');
    }
  }

  /// Creates a new medical passport
  /// Throws [MedicalPassportException] if the operation fails
  Future<bool> createMedicalPassport(MedicalPassport medicalPassport) async {
    try {
      final response = await MedicalPassportApi.createMedicalPassport(medicalPassport.toJson());
      final error = response.$2;

      if (error.isNotEmpty) {
        throw MedicalPassportException('Failed to create medical passport: $error');
      }

      return response.$1;
    } catch (e) {
      throw MedicalPassportException('Error creating medical passport: $e');
    }
  }

  /// Updates an existing medical passport
  /// Throws [MedicalPassportException] if the operation fails
  Future<bool> updateMedicalPassport(MedicalPassport medicalPassport) async {
    try {
      final (data, error) = await MedicalPassportApi.updateMedicalPassport(medicalPassport.toJson());
      if (error.isNotEmpty) {
        throw MedicalPassportException('Failed to update medical passport: $error');
      }
      return data;
    } catch (e) {
      throw MedicalPassportException('Error updating medical passport: $e');
    }
  }

  /// Deletes a medical passport by ID
  /// Throws [MedicalPassportException] if the operation fails
  Future<bool> deleteMedicalPassport(String patientId) async {
    try {
      final (data, error) = await MedicalPassportApi.deleteMedicalPassport(patientId);
      if (error.isNotEmpty) {
        throw MedicalPassportException('Failed to delete medical passport: $error');
      }
      return data;
    } catch (e) {
      throw MedicalPassportException('Error deleting medical passport: $e');
    }
  }

  /// Deletes a procedure by ID
  /// Throws [MedicalPassportException] if the operation fails
  Future<bool> deleteProcedure(String procedureId) async {
    try {
      final (success, error) = await MedicalPassportApi.deleteProcedure(procedureId);
      if (error.isNotEmpty) {
        throw MedicalPassportException('Failed to delete procedure: $error');
      }
      return success;
    } catch (e) {
      throw MedicalPassportException('Error deleting procedure: $e');
    }
  }

  /// Deletes a residual lesion by ID
  /// Throws [MedicalPassportException] if the operation fails
  Future<bool> deleteResidualLesion(String lesionId) async {
    try {
      final (success, error) = await MedicalPassportApi.deleteResidualLesion(lesionId);
      if (error.isNotEmpty) {
        throw MedicalPassportException('Failed to delete residual lesion: $error');
      }
      return success;
    } catch (e) {
      throw MedicalPassportException('Error deleting residual lesion: $e');
    }
  }
}

/// Custom exception class for medical passport related errors
class MedicalPassportException implements Exception {
  final String message;

  MedicalPassportException(this.message);

  @override
  String toString() => 'MedicalPassportException: $message';
}
