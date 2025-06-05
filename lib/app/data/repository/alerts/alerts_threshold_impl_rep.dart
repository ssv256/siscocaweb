import 'package:domain/domain.dart';
import 'package:siscoca/app/data/services/alerts/alerts_threshold_service.dart';

class AlertThresholdRepositoryImpl implements IAlertThresholdRepository {
  final AlertThresholdService _service;

  AlertThresholdRepositoryImpl(this._service);

  @override
  Future<List<AlertThreshold>> getAlertThresholds() =>
      _service.getAlertThresholds();

  @override
  Future<AlertThreshold> createAlertThreshold(AlertThreshold threshold) =>
      _service.createAlertThreshold(threshold);

  @override
  Future<AlertThreshold> updateAlertThreshold(int id, AlertThreshold threshold) =>
      _service.updateAlertThreshold(id, threshold);

  @override
  Future<void> deleteAlertThreshold(int id) =>
      _service.deleteAlertThreshold(id);

  @override
  Future<List<AlertThreshold>> getThresholdsByPatient(String patientId) =>
      _service.getThresholdsByPatient(patientId);
}