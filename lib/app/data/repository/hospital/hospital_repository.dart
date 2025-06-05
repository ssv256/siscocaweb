import 'package:domain/domain.dart';
import 'package:siscoca/app/data/services/hospital/hospital_service.dart';

class HospitalRepository {
  final HospitalService _service;

  HospitalRepository(this._service);

  /// Retrieves all hospitals from the data source
  Future<List<Hospital>> getHospitals() => _service.getHospitals();

  /// Creates a new hospital record
  Future<Hospital> createHospital(Hospital hospital) => 
      _service.createHospital(hospital);

  /// Updates an existing hospital's information
  Future<Hospital> updateHospital(int id, Hospital hospital) => 
      _service.updateHospital(id, hospital);

  /// Deletes a hospital record by ID
  Future<void> deleteHospital(int id) => _service.deleteHospital(id);
}