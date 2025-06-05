import 'package:api/api.dart';
import 'package:domain/models/models.dart';

class AlertThresholdService {
  Future<List<AlertThreshold>> getAlertThresholds() async {
    try {
      final (data, error) = await AlertThresholdApi.getAlertThresholds();
      if (error.isNotEmpty) {
        throw AlertThresholdException('Failed to fetch alert thresholds: $error');
      }
      return data?.map((json) => AlertThreshold.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw AlertThresholdException('Error fetching alert thresholds: $e');
    }
  }

  Future<AlertThreshold> createAlertThreshold(AlertThreshold threshold) async {
    try {
      final (data, error) = await AlertThresholdApi.postAlertThreshold(threshold.toJson());
      if (error.isNotEmpty) {
        throw AlertThresholdException('Failed to create alert threshold: $error');
      }
      return AlertThreshold.fromJson(data!);
    } catch (e) {
      throw AlertThresholdException('Error creating alert threshold: $e');
    }
  }

  Future<AlertThreshold> updateAlertThreshold(int id, AlertThreshold threshold) async {
    try {
      final (data, error) = await AlertThresholdApi.putAlertThreshold(id, threshold.toJson());
      if (error.isNotEmpty) {
        throw AlertThresholdException('Failed to update alert threshold: $error');
      }
      return AlertThreshold.fromJson(data!);
    } catch (e) {
      throw AlertThresholdException('Error updating alert threshold: $e');
    }
  }

  Future<void> deleteAlertThreshold(int id) async {
    try {
      final error = await AlertThresholdApi.deleteAlertThreshold(id);
      if (error.isNotEmpty) {
        throw AlertThresholdException('Failed to delete alert threshold: $error');
      }
    } catch (e) {
      throw AlertThresholdException('Error deleting alert threshold: $e');
    }
  }

  Future<List<AlertThreshold>> getThresholdsByPatient(String patientId) async {
    try {
      final (data, error) = await AlertThresholdApi.getThresholdsByPatient(patientId);
      if (error.isNotEmpty) {
        throw AlertThresholdException('Failed to fetch thresholds by measure type: $error');
      }
      return data?.map((json) => AlertThreshold.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw AlertThresholdException('Error fetching thresholds by measure type: $e');
    }
  }
}

class AlertThresholdException implements Exception {
  final String message;
  AlertThresholdException(this.message);

  @override
  String toString() => 'AlertThresholdException: $message';
}