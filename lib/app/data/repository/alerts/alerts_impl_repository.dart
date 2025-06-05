import 'package:domain/domain.dart';
import 'package:siscoca/app/data/services/alerts/alerts_service.dart';

class AlertRepositoryImpl implements IAlertRepository {
  final AlertService _service;

  AlertRepositoryImpl(this._service);

  @override
  Future<List<Alert>> getAlerts() => _service.getAlerts();

  @override
  Future<Alert> createAlert(Alert alert) => _service.createAlert(alert);

  @override
  Future<Alert> updateAlert(Alert alert) => _service.updateAlert(alert);

  @override
  Future<void> deleteAlert(String id) => _service.deleteAlert(id);

  @override
  Future<List<Alert>> getPatientAlerts(String patientId) => _service.getPatientAlerts(patientId);

  @override
  Future<Alert> markAsRead(String id, String doctorId) => _service.markAsRead(id, doctorId);

  Future<int> getTotalAlerts() => _service.getTotalAlerts();
}