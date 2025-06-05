import 'package:api/api.dart';
import 'package:domain/models/models.dart';
/// Service class for handling patient-related operations
class PatientService {
  Future<List<User>> getPatients() async {
    try {
      final (data, error) = await CococarePatientApi.getPatients();
      if (error.isNotEmpty) {
        throw PatientException('Failed to fetch patients: $error');
      }
      return data?.map((json) => User.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw PatientException('Error fetching patients: $e');
    }
  }

  /// Get patient by ID
  Future<User> getPatientById(String id) async {
    try {
      final (data, error) = await CococarePatientApi.getPatientById(id);
      if (error.isNotEmpty) {
        throw PatientException('Failed to fetch patient: $error');
      }
      return User.fromJson(data!);
    } catch (e) {
      throw PatientException('Error fetching patient: $e');
    }
  }

  /// Get patient by ID
  Future<List<User>> getPatientsByStudyId(String id) async {
    try {
      final (data, error) = await CococarePatientApi.getPatientsByStudyId(id);
      if (error.isNotEmpty) {
        throw PatientException('Failed to fetch patient: $error');
      }
      return data?.map((json) => User.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw PatientException('Error fetching patient: $e');
    }
  }

  /// Create a new patient
  Future<User> createPatient(User patient) async {
    try {
      final (data, error) = await CococarePatientApi.postPatient(patient.toJson());
      if (error.isNotEmpty) {
        throw PatientException('Failed to create patient: $error');
      }
      return User.fromJson(data!);
    } catch (e) {
      throw PatientException('Error creating patient: $e');
    }
  }

  /// Update an existing patient
  Future<User> updatePatient(User patient) async {
    try {
      final (data, error) = await CococarePatientApi.putPatient(patient.toJson());
      if (error.isNotEmpty) {
        throw PatientException('Failed to update patient: $error');
      }
      return User.fromJson(data!);
    } catch (e) {
      throw PatientException('Error updating patient: $e');
    }
  }

  /// Delete a patient by ID
  Future<void> deletePatient(String id) async {
    try {
      final error = await CococarePatientApi.deleteMedicalPassportPatient(id);
      if (error.isNotEmpty) {
        throw PatientException('Failed to delete patient: $error');
      }
    } catch (e) {
      throw PatientException('Error deleting patient: $e');
    }
  }

  /// Update patient device token
  Future<void> updateDeviceToken(String patientId, String deviceToken) async {
    try {
      final error = await CococarePatientApi.updateDeviceToken(patientId, deviceToken);
      if (error.isNotEmpty) {
        throw PatientException('Failed to update device token: $error');
      }
    } catch (e) {
      throw PatientException('Error updating device token: $e');
    }
  }
}

/// Custom exception class for patient-related errors
class PatientException implements Exception {
  final String message;
  
  PatientException(this.message);
  
  @override
  String toString() => 'PatientException: $message';
}