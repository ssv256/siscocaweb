import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/charts/date_range.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'util.dart';

class StepsChart extends GetView<PatientsDetailController> {
  const StepsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final Rx<int> selectedDays = 30.obs;
    final Rx<bool> isAnimating = true.obs;
    final Rx<bool> showReadingsList = false.obs;
    
    return Obx(() {
      // Get raw readings from health data
      final rawReadings = processHealthData(
        dataType: HealthDataType.STEPS,
        healthDataPoints: controller.healthDataPoints,
        daysRange: selectedDays.value,
        createReading: (date, value) {
          // Ensure the value is an integer
          int steps;
          
          // Handle different value formats
          if (value is Map && value.containsKey('numericValue')) {
            // Handle NumericHealthValue as JSON object
            steps = (value['numericValue'] is num) 
                ? value['numericValue'].toInt() 
                : int.tryParse(value['numericValue'].toString()) ?? 0;
          } else if (value is double) {
            steps = value.toInt();
          } else if (value is int) {
            steps = value;
          } else {
            // Try to parse as string
            steps = int.tryParse(value.toString()) ?? 0;
          }
          
          return StepsReading(date, steps);
        }
      );
      
      // Process readings to ensure consistent data points
      final readings = _processReadingsForChart(rawReadings, selectedDays.value);
      
      // Sort readings by date (newest first) for the list view
      final sortedReadings = List<StepsReading>.from(rawReadings)
        ..sort((a, b) => b.date.compareTo(a.date));

      // Calculate min, max, and average steps
      // int minSteps = 0;
      int maxSteps = 0;
      double avgSteps = 0;
      int totalSteps = 0;
      
      if (readings.isNotEmpty) {
        // minSteps = readings.map((r) => r.steps).reduce((a, b) => a < b ? a : b);
        maxSteps = readings.map((r) => r.steps).reduce((a, b) => a > b ? a : b);
        totalSteps = readings.map((r) => r.steps).reduce((a, b) => a + b);
        avgSteps = totalSteps / readings.length;
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
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_walk,
                        color: Color(0xFF2B6CB0),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Pasos',
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
                                    color: const Color(0xFF2B6CB0).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    showReadingsList.value ? Icons.bar_chart_rounded : Icons.view_list_rounded,
                                    color: const Color(0xFF2B6CB0),
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
                    title: 'Promedio',
                    value: '${avgSteps.toStringAsFixed(0)}',
                    unit: ' pasos',
                    icon: Icons.horizontal_rule,
                    color: const Color(0xFF2B6CB0),
                  ),
                  _buildStatCard(
                    title: 'Máximo',
                    value: '$maxSteps',
                    unit: ' pasos',
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: 'Total',
                    value: NumberFormat.compact().format(totalSteps),
                    unit: ' pasos',
                    icon: Icons.add,
                    color: Colors.orange,
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
                            Icons.directions_walk,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay datos de pasos disponibles',
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
                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      enableAxisAnimation: true,
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 12,
                        ),
                      ),
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.MMMd(),
                        intervalType: DateTimeIntervalType.days,
                        interval: selectedDays.value <= 7 ? 1 :
                                 selectedDays.value <= 14 ? 2 :
                                 selectedDays.value <= 30 ? 5 :
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
                        // Improve readability when there are many data points
                        labelRotation: readings.length > 15 ? -45 : 0,
                        labelAlignment: readings.length > 15 ? LabelAlignment.end : LabelAlignment.center,
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        // Set a dynamic maximum based on the highest value
                        maximum: maxSteps > 0 ? (maxSteps * 1.2).roundToDouble() : 10000,
                        // Adjust interval based on the maximum value
                        interval: _calculateYAxisInterval(maxSteps),
                        labelFormat: '{value}',
                        numberFormat: NumberFormat.compact(),
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
                      series: <CartesianSeries<StepsReading, DateTime>>[
                        // Column series for steps
                        ColumnSeries<StepsReading, DateTime>(
                          name: 'Pasos',
                          dataSource: readings,
                          color: const Color(0xFF2B6CB0),
                          width: 0.7, // Width of the columns
                          spacing: 0.3, // Space between columns
                          borderRadius: BorderRadius.circular(4),
                          xValueMapper: (StepsReading steps, _) => steps.date,
                          yValueMapper: (StepsReading steps, _) => steps.steps,
                          animationDuration: 1500,
                          // Enable gradients for better visual appeal
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF4299E1),
                              const Color(0xFF2B6CB0),
                            ],
                          ),
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                          onRendererCreated: (ChartSeriesController controller) {
                            if (isAnimating.value) {
                              Future.delayed(const Duration(milliseconds: 2000), () {
                                isAnimating.value = false;
                              });
                            }
                          },
                          enableTooltip: true,
                          isVisibleInLegend: true,
                          legendIconType: LegendIconType.rectangle,
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        color: Colors.white,
                        elevation: 10,
                        animationDuration: 150,
                        duration: 3000,
                        format: 'point.x: point.y pasos',
                        canShowMarker: true,
                        textStyle: const TextStyle(color: Color(0xFF2D3748)),
                        builder: (dynamic data, dynamic point, dynamic series,
                                int pointIndex, int seriesIndex) {
                          final StepsReading reading = data;
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
                                    const Icon(
                                      Icons.directions_walk,
                                      color: Color(0xFF2B6CB0),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      NumberFormat.decimalPattern().format(reading.steps),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A202C),
                                      ),
                                    ),
                                    const Text(
                                      ' pasos',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('dd MMM yyyy').format(reading.date),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _getActivityLevel(reading.steps),
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
  
  Widget _buildReadingsList(List<StepsReading> readings) {
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
            'Historial de Pasos',
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
              final status = _getActivityLevelInfo(reading.steps);
              
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
                          color: const Color(0xFF2B6CB0).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B6CB0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Icon
                      Icon(
                        Icons.directions_walk,
                        color: status.color,
                        size: 20,
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
                                  NumberFormat.decimalPattern().format(reading.steps),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: status.color,
                                  ),
                                ),
                                Text(
                                  ' pasos',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: status.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status.label,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: status.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM yyyy').format(reading.date),
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
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _getActivityLevel(int steps) {
    final status = _getActivityLevelInfo(steps);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: status.color,
        ),
      ),
    );
  }
  
  ActivityStatusInfo _getActivityLevelInfo(int steps) {
    if (steps >= 10000) {
      return ActivityStatusInfo('Muy activo', Colors.green);
    } else if (steps >= 7500) {
      return ActivityStatusInfo('Activo', Colors.lightGreen);
    } else if (steps >= 5000) {
      return ActivityStatusInfo('Moderado', Colors.amber);
    } else if (steps >= 2500) {
      return ActivityStatusInfo('Bajo', Colors.orange);
    } else {
      return ActivityStatusInfo('Sedentario', Colors.red);
    }
  }
  
  double _calculateYAxisInterval(int maxSteps) {
    if (maxSteps <= 0) return 1000;
    if (maxSteps <= 5000) return 500;
    if (maxSteps <= 10000) return 1000;
    if (maxSteps <= 25000) return 5000;
    return 10000;
  }
}

class StepsReading {
  final DateTime date;
  final int steps;
  StepsReading(this.date, this.steps);
}

class ActivityStatusInfo {
  final String label;
  final Color color;
  
  ActivityStatusInfo(this.label, this.color);
}

List<StepsReading> _processReadingsForChart(List<StepsReading> rawReadings, int daysRange) {
  if (rawReadings.isEmpty) {
    return [];
  }
  
  // Sort readings by date
  rawReadings.sort((a, b) => a.date.compareTo(b.date));
  
  // For steps data, we typically want to see daily totals rather than individual readings
  // Create a map to store daily total steps
  final Map<String, int> stepsByDay = {};
  final Map<String, DateTime> dateByDay = {};
  
  // Group steps by day and calculate daily totals
  for (final reading in rawReadings) {
    final dateKey = DateFormat('yyyy-MM-dd').format(reading.date);
    
    if (!dateByDay.containsKey(dateKey)) {
      dateByDay[dateKey] = reading.date;
    }
    
    if (stepsByDay.containsKey(dateKey)) {
      stepsByDay[dateKey] = stepsByDay[dateKey]! + reading.steps;
    } else {
      stepsByDay[dateKey] = reading.steps;
    }
  }
  
  // Create a list of daily step readings
  final List<StepsReading> processedReadings = [];
  
  stepsByDay.forEach((date, steps) {
    processedReadings.add(StepsReading(dateByDay[date]!, steps));
  });
  
  // Sort the processed readings
  processedReadings.sort((a, b) => a.date.compareTo(b.date));
  
  return processedReadings;
} 