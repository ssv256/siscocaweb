import 'package:api/api.dart';
import 'package:domain/models/models.dart';

class AlertService {
  Future<List<Alert>> getAlerts() async {
  try {
    final (data, error) = await AlertApi.getAlerts();
    if (error.isNotEmpty) {
      throw AlertException('Failed to fetch alerts: $error');
    }
    return data?.map((json) => Alert.fromJson(json as Map<String, dynamic>)).toList() ?? [];
  } catch (e) {
    throw AlertException('Error fetching alerts: $e');
  }
}

  Future<Alert> createAlert(Alert alert) async {
    try {
      final (data, error) = await AlertApi.postAlert(alert.toJson());
      if (error.isNotEmpty) {
        throw AlertException('Failed to create alert: $error');
      }
      return Alert.fromJson(data!);
    } catch (e) {
      throw AlertException('Error creating alert: $e');
    }
  }

  Future<Alert> updateAlert( Alert alert) async {
    try {
      final (data, error) = await AlertApi.putAlert(alert.toJson());
      if (error.isNotEmpty) {
        throw AlertException('Failed to update alert: $error');
      }
      return Alert.fromJson(data!);
    } catch (e) {
      throw AlertException('Error updating alert: $e');
    }
  }

  Future<void> deleteAlert(String id) async {
    try {
      final error = await AlertApi.deleteAlert(id);
      if (error.isNotEmpty) {
        throw AlertException('Failed to delete alert: $error');
      }
    } catch (e) {
      throw AlertException('Error deleting alert: $e');
    }
  }

  Future<List<Alert>> getPatientAlerts(String patientId) async {
    try {
      final (data, error) = await AlertApi.getPatientAlerts(patientId);
      if (error.isNotEmpty) {
        throw AlertException('Failed to fetch patient alerts: $error');
      }
      return data?.map((json) => Alert.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw AlertException('Error fetching patient alerts: $e');
    }
  }

  Future<Alert> markAsRead(String id, String doctorId) async {
    try {
      final (data, error) = await AlertApi.markAlertAsRead(id, doctorId);
      if (error.isNotEmpty) {
        throw AlertException('Failed to mark alert as read: $error');
      }
      return Alert.fromJson(data!);
    } catch (e) {
      throw AlertException('Error marking alert as read: $e');
    }
  }

  Future<int> getTotalAlerts() async {
    try {
      final (data, error) = await AlertApi.getTotalAlerts();
      if (error.isNotEmpty) {
        throw AlertException('Failed to mark alert as read: $error');
      }
      return data!;
    } catch (e) {
      throw AlertException('Error marking alert as read: $e');
    }
  }
}

class AlertException implements Exception {
  final String message;
  AlertException(this.message);

  @override
  String toString() => 'AlertException: $message';
}
