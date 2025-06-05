import 'package:api/api.dart';
import 'package:domain/domain.dart';

class DoctorService {
  Future<List<Doctor>> getDoctors() async {
    try {
      final (data, error) = await DoctorApi.getDoctors();
      if (error.isNotEmpty) {
        throw DoctorException('Failed to fetch doctors: $error');
      }
      return data?.map((json) => Doctor.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw DoctorException('Error fetching doctors: $e');
    }
  }

  Future<Doctor> createDoctor(Doctor doctor) async {
    try {
      final (data, error) = await DoctorApi.postDoctor(doctor.toJson());
      if (error.isNotEmpty) {
        throw DoctorException('Failed to create doctor: $error');
      }
      return Doctor.fromJson(data!);
    } catch (e) {
      throw DoctorException('Error creating doctor: $e');
    }
  }

  Future<Doctor> updateDoctor(String id, Doctor doctor) async {
    try {
      final (data, error) = await DoctorApi.putDoctor(id, doctor.toJson());
      if (error.isNotEmpty) {
        throw DoctorException('Failed to update doctor: $error');
      }
      return Doctor.fromJson(data!);
    } catch (e) {
      throw DoctorException('Error updating doctor: $e');
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      final error = await DoctorApi.deleteDoctor(id);
      if (error.isNotEmpty) {
        throw DoctorException('Failed to delete doctor: $error');
      }
    } catch (e) {
      throw DoctorException('Error deleting doctor: $e');
    }
  }
}

class DoctorException implements Exception {
  final String message;
  DoctorException(this.message);

  @override
  String toString() => 'DoctorException: $message';
}