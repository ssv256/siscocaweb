import 'package:api/api.dart';
import 'package:health/health.dart';

class MeasureService {
  Future<List<HealthDataPoint>> getHealthDataPoints(String patientId) async {
    try {
      final response = await MeasuresApi.getHealthDataPoints(patientId);
      return response.map((data) => HealthDataPoint.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch health data points: $e');
    }
  }

  Future<List<Map<DateTime, int>>> getTotalMeasuresWeek() async {
    try {
      final List<Map<String, dynamic>> response =
          await MeasuresApi.getTotalWeekMeasures();

      // Parse the data into a List<Map<DateTime, int>>
      final List<Map<DateTime, int>> parsedData = response.map((item) {
        final String dateString = item.keys.first;
        final int value = item[dateString];
        final DateTime date = DateTime.parse(dateString);
        return {date: value};
      }).toList();

      final DateTime now = DateTime.now();
      final DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Filter the data to include only the last 7 days
      final List<Map<DateTime, int>> lastWeekData = parsedData.where((item) {
        final DateTime date = item.keys.first;
        return date.isAfter(sevenDaysAgo) ||
            date.isAtSameMomentAs(sevenDaysAgo);
      }).toList();

      return lastWeekData;
    } catch (e) {
      throw Exception('Failed to fetch weekly measures: $e');
    }
  }

  Future<Map<DateTime, int>> getTotalHealthDataPoints(String patientId) async {
    try {
      final response = await MeasuresApi.fetchTotalHealthDataPoints(patientId);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch total health data points: $e');
    }
  }
}
