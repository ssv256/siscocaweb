import 'package:health/health.dart';
import 'package:siscoca/app/data/services/patients/measures.dart';

/// Repository class for managing health measurements-related operations
class MeasureRepository {
  final MeasureService _service;

  MeasureRepository(this._service);

  /// Retrieves health data points for a specific patient
  Future<List<HealthDataPoint>> getHealthDataPoints(String patientId) => 
    _service.getHealthDataPoints(patientId);

  Future<List<Map<DateTime, int>>> getTotalMeasuresWeek() =>
    _service.getTotalMeasuresWeek();

  Future<Map<DateTime, int>> getTotalHealthDataPoints(String patientId) =>
    _service.getTotalHealthDataPoints(patientId);

}