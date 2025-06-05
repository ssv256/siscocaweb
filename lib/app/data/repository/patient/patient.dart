
import 'package:domain/models/models.dart';
import 'package:siscoca/app/data/services/patients/patients.dart';

/// Repository class for managing patient-related operations
class PatientRepository {
  final PatientService _service;

  PatientRepository(this._service);

  /// Retrieves all patients from the data source
  Future<List<User>> getPatients() => _service.getPatients();

  /// Retrieves a specific patient by ID
  Future<User> getPatientsById(String id) => _service.getPatientById(id);

  /// Retrieves a specific patient by studyID
  Future<List<User>> getPatientByStudyId(String id) => _service.getPatientsByStudyId(id);

  /// Creates a new patient record
  Future<User> createPatient(User patient) => _service.createPatient(patient);

  /// Updates an existing patient's information
  Future<User> updatePatient(User patient) => _service.updatePatient(patient);

  /// Deletes a patient record by ID
  Future<void> deletePatient(String id) => _service.deletePatient(id);

}