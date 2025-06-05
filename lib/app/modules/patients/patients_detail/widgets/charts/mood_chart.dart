import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/charts/date_range.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'util.dart';

class MoodChart extends GetView<PatientsDetailController> {
  const MoodChart({super.key});

  @override
  Widget build(BuildContext context) {
    final Rx<int> selectedDays = 30.obs;
    final Rx<bool> isAnimating = true.obs;
    final Rx<bool> showReadingsList = false.obs;

    return Obx(() {
      final rawReadings = processHealthData(
        dataType: HealthDataType.MOOD,
        healthDataPoints: controller.healthDataPoints,
        daysRange: selectedDays.value,
        createReading: (date, value) {
          int mood;
          
          // Handle different value formats
          if (value is Map && value.containsKey('moodRating')) {
            final moodValue = value['moodRating'];
            mood = moodValue is num 
                ? moodValue.toInt() 
                : int.tryParse(moodValue.toString()) ?? 5;
          } else if (value is num) {
            mood = value.toInt();
          } else {
            // Try to parse as string
            mood = int.tryParse(value.toString()) ?? 5;
          }
          
          return MoodReading(date, mood);
        }
      );
      
      // Process readings to ensure consistent data points
      final readings = _processReadingsForChart(rawReadings, selectedDays.value);
      
      // Sort readings by date (newest first) for the list view
      final sortedReadings = List<MoodReading>.from(rawReadings)
        ..sort((a, b) => b.date.compareTo(a.date));

      // Calculate min, max, and average mood
      int minMood = 0;
      int maxMood = 0;
      double avgMood = 0;
      
      if (readings.isNotEmpty) {
        minMood = readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);
        maxMood = readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);
        avgMood = readings.map((r) => r.value).reduce((a, b) => a + b) / readings.length;
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.mood,
                        color: Color(0xFFECC94B),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Estado de Ánimo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A202C),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Enhanced toggle button with better visual cue and more intuitive design
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            showReadingsList.value = !showReadingsList.value;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECC94B).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    showReadingsList.value ? Icons.bar_chart_rounded : Icons.view_list_rounded,
                                    color: const Color(0xFFECC94B),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  showReadingsList.value ? 'Ver gráfico' : 'Ver lista',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4A5568),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 130,
                      child: DateRangeDropdown(
                        selectedDays: selectedDays.value,
                        onDaysChanged: (value) {
                          selectedDays.value = value;
                          isAnimating.value = true;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (readings.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    title: 'Mínimo',
                    value: getMoodEmoji(minMood),
                    subtitle: getMoodText(minMood, context),
                    icon: Icons.arrow_downward,
                    color: _getMoodColor(minMood),
                  ),
                  _buildStatCard(
                    title: 'Promedio',
                    value: getMoodEmoji(avgMood.round()),
                    subtitle: getMoodText(avgMood.round(), context),
                    icon: Icons.horizontal_rule,
                    color: _getMoodColor(avgMood.round()),
                  ),
                  _buildStatCard(
                    title: 'Máximo',
                    value: getMoodEmoji(maxMood),
                    subtitle: getMoodText(maxMood, context),
                    icon: Icons.arrow_upward,
                    color: _getMoodColor(maxMood),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            Expanded(
              child: readings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mood_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay datos de estado de ánimo disponibles',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Los datos se mostrarán cuando estén disponibles',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : showReadingsList.value
                  ? _buildReadingsList(sortedReadings)
                  : SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      margin: const EdgeInsets.all(0),
                      enableAxisAnimation: true,
                      legend: Legend(
                        isVisible: false,
                      ),
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.MMMd(),
                        intervalType: DateTimeIntervalType.days,
                        interval: selectedDays.value <= 30 ? 5 :
                                 selectedDays.value <= 90 ? 15 : 30,
                        minimum: DateTime.now().subtract(Duration(days: selectedDays.value)),
                        maximum: DateTime.now(),
                        majorGridLines: const MajorGridLines(width: 0),
                        minorGridLines: const MinorGridLines(width: 0),
                        axisLine: const AxisLine(width: 1, color: Color(0xFFE2E8F0)),
                        labelStyle: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 12,
                        ),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        rangePadding: ChartRangePadding.round,
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 10,
                        interval: 1,
                        labelFormat: '{value}',
                        labelStyle: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 12,
                        ),
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(
                          width: 1,
                          color: Colors.grey[200],
                          dashArray: const <double>[5, 5],
                        ),
                      ),
                      series: <CartesianSeries<MoodReading, DateTime>>[
                        // Area series for gradient background
                        AreaSeries<MoodReading, DateTime>(
                          dataSource: readings,
                          xValueMapper: (MoodReading mood, _) => mood.date,
                          yValueMapper: (MoodReading mood, _) => mood.value,
                          animationDuration: 1500,
                          animationDelay: 500,
                          enableTooltip: false,
                          borderWidth: 0,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFECC94B).withOpacity(0.3),
                              const Color(0xFFECC94B).withOpacity(0.05),
                            ],
                          ),
                          emptyPointSettings: EmptyPointSettings(
                            mode: EmptyPointMode.gap,
                          ),
                        ),
                        // Line series for the main line
                        SplineSeries<MoodReading, DateTime>(
                          dataSource: readings,
                          color: const Color(0xFFECC94B),
                          width: 3,
                          xValueMapper: (MoodReading mood, _) => mood.date,
                          yValueMapper: (MoodReading mood, _) => mood.value,
                          animationDuration: 1500,
                          // Set to connect the line across empty points
                          emptyPointSettings: EmptyPointSettings(
                            mode: EmptyPointMode.drop,
                            color: const Color(0xFFECC94B).withOpacity(0.3),
                          ),
                          // Enable spline type that connects across gaps
                          splineType: SplineType.monotonic,
                          cardinalSplineTension: 0.5,
                          // Enable this to ensure the line is continuous
                          enableTooltip: true,
                          // This ensures the line is drawn even with few data points
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            height: 8,
                            width: 8,
                            shape: DataMarkerType.circle,
                            borderWidth: 2,
                            borderColor: Color(0xFFECC94B),
                            color: Colors.white,
                          ),
                          onRendererCreated: (ChartSeriesController controller) {
                            if (isAnimating.value) {
                              Future.delayed(const Duration(milliseconds: 2000), () {
                                isAnimating.value = false;
                              });
                            }
                          },
                          // Custom data marker to show emoji
                          dataLabelMapper: (MoodReading mood, _) => getMoodEmoji(mood.value),
                          pointColorMapper: (MoodReading mood, _) => _getMoodColor(mood.value),
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        color: Colors.white,
                        elevation: 10,
                        animationDuration: 150,
                        duration: 3000,
                        textStyle: const TextStyle(color: Color(0xFF2D3748)),
                        builder: (dynamic data, dynamic point, dynamic series,
                                int pointIndex, int seriesIndex) {
                          final MoodReading reading = data;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      getMoodEmoji(reading.value),
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      getMoodText(reading.value, context),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _getMoodColor(reading.value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('dd MMM yyyy, HH:mm').format(reading.date),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
  
  Widget _buildReadingsList(List<MoodReading> readings) {
    if (readings.isEmpty) {
      return const Center(
        child: Text('No hay lecturas disponibles'),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            'Historial de Estados de Ánimo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: readings.length,
            itemBuilder: (context, index) {
              final reading = readings[index];
              final color = _getMoodColor(reading.value);
              final emoji = getMoodEmoji(reading.value);
              final moodText = getMoodText(reading.value, context);
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Order number with circle background
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECC94B).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFECC94B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Emoji
                      Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Value and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  moodText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Nivel ${reading.value}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm').format(reading.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Color _getMoodColor(int value) {
    if (value >= 8) return Colors.green;
    if (value >= 6) return Colors.lightGreen;
    if (value >= 5) return const Color(0xFFECC94B);
    if (value >= 3) return Colors.orange;
    return Colors.red;
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class MoodReading {
  final DateTime date;
  final int value;
  MoodReading(this.date, this.value);
}

List<MoodReading> _processReadingsForChart(List<MoodReading> rawReadings, int daysRange) {
  if (rawReadings.isEmpty) {
    return [];
  }
  
  // Sort readings by date
  rawReadings.sort((a, b) => a.date.compareTo(b.date));
  
  // Create a map to store readings by date (using day as key)
  final Map<String, MoodReading> readingsByDay = {};
  
  // Group readings by day and use the average value for each day
  for (final reading in rawReadings) {
    final dateKey = DateFormat('yyyy-MM-dd').format(reading.date);
    
    if (readingsByDay.containsKey(dateKey)) {
      // If we already have a reading for this day, use the average
      final existingReading = readingsByDay[dateKey]!;
      final newValue = (existingReading.value + reading.value) ~/ 2;
      readingsByDay[dateKey] = MoodReading(existingReading.date, newValue);
    } else {
      // Otherwise, add the reading
      readingsByDay[dateKey] = reading;
    }
  }
  
  // Create a list with all readings, without filtering
  final List<MoodReading> processedReadings = [];
  
  // Add all readings from the map to our processed list
  processedReadings.addAll(readingsByDay.values);
  
  // Sort the processed readings
  processedReadings.sort((a, b) => a.date.compareTo(b.date));
  
  return processedReadings;
}