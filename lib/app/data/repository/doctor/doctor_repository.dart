import 'package:domain/domain.dart';
import 'package:siscoca/app/data/services/doctor/doctor_service.dart';

class DoctorRepository {
  final DoctorService _service;

  DoctorRepository(this._service);

  /// Retrieves all doctors from the data source
  Future<List<Doctor>> getDoctors() => _service.getDoctors();

  /// Creates a new doctor record
  Future<Doctor> createDoctor(Doctor doctor) => _service.createDoctor(doctor);

  /// Updates an existing doctor's information
  Future<Doctor> updateDoctor(String id, Doctor doctor) => _service.updateDoctor(id, doctor);

  /// Deletes a doctor record by ID
  Future<void> deleteDoctor(String id) => _service.deleteDoctor(id);
}