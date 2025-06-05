
import 'package:api/api.dart';
import 'package:domain/domain.dart';

class HospitalService {
  Future<List<Hospital>> getHospitals() async {
    try {
      final (data, error) = await HospitalApi.getHospitals();
      if (error.isNotEmpty) {
        throw HospitalException('Failed to fetch hospitals: $error');
      }
      return data?.map((json) => Hospital.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw HospitalException('Error fetching hospitals: $e');
    }
  }

  Future<Hospital> createHospital(Hospital hospital) async {
    try {
      final (data, error) = await HospitalApi.postHospital(hospital.toJson());
      if (error.isNotEmpty) {
        throw HospitalException('Failed to create hospital: $error');
      }
      return Hospital.fromJson(data!);
    } catch (e) {
      throw HospitalException('Error creating hospital: $e');
    }
  }

  Future<Hospital> updateHospital(int id, Hospital hospital) async {
    try {
      final (data, error) = await HospitalApi.putHospital(id, hospital.toJson());
      if (error.isNotEmpty) {
        throw HospitalException('Failed to update hospital: $error');
      }
      return Hospital.fromJson(data!);
    } catch (e) {
      throw HospitalException('Error updating hospital: $e');
    }
  }

  Future<void> deleteHospital(int id) async {
    try {
      final (data, error) = await HospitalApi.deleteHospital(id);
      if (error.isNotEmpty) {
        throw HospitalException('Failed to delete hospital: $error');
      }
      return;
    } catch (e) {
      throw HospitalException('Error deleting hospital: $e');
    }
  }
}

class HospitalException implements Exception {
  final String message;
  HospitalException(this.message);

  @override
  String toString() => 'HospitalException: $message';
}