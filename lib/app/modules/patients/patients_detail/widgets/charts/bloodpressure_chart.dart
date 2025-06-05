// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/charts/date_range.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/health.dart';

import 'util.dart';

class BloodPressureChart extends GetView<PatientsDetailController> {
  const BloodPressureChart({super.key});

  Color _getSystolicColor(int value) {
    if (value >= 140) return const Color(0xFFE53E3E);
    if (value >= 130) return const Color(0xFFED8936);
    if (value >= 71) return const Color(0xFF68D391);
    if (value >= 60) return const Color(0xFFED8936);
    return const Color(0xFFE53E3E);
  }

  Color _getDiastolicColor(int value) {
    if (value >= 90) return const Color(0xFFE53E3E);
    if (value >= 80) return const Color(0xFFED8936);
    if (value >= 60) return const Color(0xFF63B3ED);
    if (value >= 50) return const Color(0xFFED8936);
    return const Color(0xFFE53E3E);
  }

  String _getBPStatus(int systolic, int diastolic) {
    if (systolic >= 180 || diastolic >= 120) {
      return 'Crisis hipertensiva';
    } else if (systolic >= 140 || diastolic >= 90) {
      return 'Hipertensión';
    } else if (systolic >= 130 || diastolic >= 80) {
      return 'Prehipertensión';
    } else if (systolic >= 90 && diastolic >= 60) {
      return 'Normal';
    } else {
      return 'Hipotensión';
    }
  }

  Color _getBPStatusColor(int systolic, int diastolic) {
    if (systolic >= 180 || diastolic >= 120) {
      return Colors.red.shade800;
    } else if (systolic >= 140 || diastolic >= 90) {
      return Colors.red;
    } else if (systolic >= 130 || diastolic >= 80) {
      return Colors.orange;
    } else if (systolic >= 90 && diastolic >= 60) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Rx<int> selectedDays = 30.obs;
    final Rx<bool> isAnimating = true.obs;
    final Rx<bool> showReadingsList = false.obs;

    return Obx(() {
      // Get raw readings from health data
      final rawReadings = processHealthData(
        dataType: HealthDataType.BLOOD_PRESSURE, 
        healthDataPoints: controller.healthDataPoints, 
        daysRange: selectedDays.value, 
        createReading: (date, value) => BPReading(
          date,
          value['systolic'],
          value['diastolic'],
        )
      );
      
      // Process readings to ensure consistent data points
      final readings = _processReadingsForChart(rawReadings, selectedDays.value);
      
      // Sort readings by date (newest first) for the list view
      final sortedReadings = List<BPReading>.from(rawReadings)
        ..sort((a, b) => b.date.compareTo(a.date));

      // Calculate min, max, and average blood pressure
      int minSystolic = 0;
      int maxSystolic = 0;
      double avgSystolic = 0;
      int minDiastolic = 0;
      int maxDiastolic = 0;
      double avgDiastolic = 0;
      
      if (readings.isNotEmpty) {
        minSystolic = readings.map((r) => r.systolic).reduce((a, b) => a < b ? a : b);
        maxSystolic = readings.map((r) => r.systolic).reduce((a, b) => a > b ? a : b);
        avgSystolic = readings.map((r) => r.systolic).reduce((a, b) => a + b) / readings.length;
        
        minDiastolic = readings.map((r) => r.diastolic).reduce((a, b) => a < b ? a : b);
        maxDiastolic = readings.map((r) => r.diastolic).reduce((a, b) => a > b ? a : b);
        avgDiastolic = readings.map((r) => r.diastolic).reduce((a, b) => a + b) / readings.length;
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
                        color: const Color(0xFFF0E6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite_outline,
                        color: Color(0xFF805AD5),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Presión Arterial',
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
                                    color: const Color(0xFF805AD5).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    showReadingsList.value ? Icons.bar_chart_rounded : Icons.view_list_rounded,
                                    color: const Color(0xFF805AD5),
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
                    title: 'Sistólica',
                    value: '${avgSystolic.toStringAsFixed(0)}',
                    unit: 'mmHg',
                    icon: Icons.arrow_upward,
                    color: _getSystolicColor(avgSystolic.toInt()),
                  ),
                  _buildStatCard(
                    title: 'Diastólica',
                    value: '${avgDiastolic.toStringAsFixed(0)}',
                    unit: 'mmHg',
                    icon: Icons.arrow_downward,
                    color: _getDiastolicColor(avgDiastolic.toInt()),
                  ),
                  _buildStatCard(
                    title: 'Estado',
                    value: _getBPStatus(avgSystolic.toInt(), avgDiastolic.toInt()),
                    unit: '',
                    icon: Icons.favorite,
                    color: _getBPStatusColor(avgSystolic.toInt(), avgDiastolic.toInt()),
                    valueSize: 14,
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
                            Icons.favorite_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay datos de presión arterial disponibles',
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
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: TextStyle(
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
                        // Ensure axis labels are visible
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        // Ensure data is properly padded within the chart
                        rangePadding: ChartRangePadding.additional,
                        // Improve readability when there are many data points
                        labelRotation: readings.length > 15 ? -45 : 0,
                        labelAlignment: readings.length > 15 ? LabelAlignment.end : LabelAlignment.center,
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 40,
                        maximum: 220,
                        interval: 20,
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
                      // Add padding to ensure lines don't get cut off
                      plotAreaBorderColor: Colors.transparent,
                      series: <CartesianSeries<BPReading, DateTime>>[
                        // Systolic line
                        LineSeries<BPReading, DateTime>(
                          name: 'Sistólica',
                          dataSource: readings,
                          color: const Color(0xFF805AD5),
                          width: 2,
                          xValueMapper: (BPReading bp, _) => bp.date,
                          yValueMapper: (BPReading bp, _) => bp.systolic,
                          animationDuration: 1500,
                          // Ensure the line is visible even with few data points
                          emptyPointSettings: const EmptyPointSettings(
                            mode: EmptyPointMode.average,
                          ),
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            height: 10,
                            width: 10,
                            shape: DataMarkerType.circle,
                            borderWidth: 2,
                            borderColor: Color(0xFF805AD5),
                            color: Colors.white,
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: readings.length <= 10,
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onRendererCreated: (ChartSeriesController controller) {
                            if (isAnimating.value) {
                              Future.delayed(const Duration(milliseconds: 2000), () {
                                isAnimating.value = false;
                              });
                            }
                          },
                          //  Ensure all points are shown
                          enableTooltip: true,
                          // Show data just with one point
                          isVisibleInLegend: true,
                          legendIconType: LegendIconType.circle,
                        ),
                        // Diastolic line
                        LineSeries<BPReading, DateTime>(
                          name: 'Diastólica',
                          dataSource: readings,
                          color: const Color(0xFF3182CE),
                          width: 2,
                          xValueMapper: (BPReading bp, _) => bp.date,
                          yValueMapper: (BPReading bp, _) => bp.diastolic,
                          animationDuration: 1500,
                          // Ensure the line is visible even with few data points
                          emptyPointSettings: const  EmptyPointSettings(
                            mode: EmptyPointMode.average,
                          ),
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            height: 10,
                            width: 10,
                            shape: DataMarkerType.circle,
                            borderWidth: 2,
                            borderColor: Color(0xFF3182CE),
                            color: Colors.white,
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: readings.length <= 10,
                            labelAlignment: ChartDataLabelAlignment.bottom,
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          enableTooltip: true,
                          isVisibleInLegend: true,
                          legendIconType: LegendIconType.circle,
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        color: Colors.white,
                        elevation: 10,
                        animationDuration: 150,
                        duration: 3000,
                        format: 'point.x : point.y mmHg',
                        canShowMarker: true,
                        textStyle: const TextStyle(color: Color(0xFF2D3748)),
                        builder: (dynamic data, dynamic point, dynamic series,
                                int pointIndex, int seriesIndex) {
                          final BPReading reading = data;
                          final bool isSystolic = seriesIndex == 0;
                          final int value = isSystolic ? reading.systolic : reading.diastolic;
                          final String label = isSystolic ? 'Sistólica' : 'Diastólica';
                          final Color color = isSystolic 
                            ? _getSystolicColor(value)
                            : _getDiastolicColor(value);
                            
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
                                    Icon(
                                      isSystolic ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: color,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$label: $value mmHg',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: color,
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
                                if (isSystolic) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getBPStatusColor(reading.systolic, reading.diastolic).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getBPStatus(reading.systolic, reading.diastolic),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: _getBPStatusColor(reading.systolic, reading.diastolic),
                                      ),
                                    ),
                                  ),
                                ],
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
  
  Widget _buildReadingsList(List<BPReading> readings) {
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
            'Historial de Lecturas',
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
              final statusColor = _getBPStatusColor(reading.systolic, reading.diastolic);
              final statusText = _getBPStatus(reading.systolic, reading.diastolic);
              
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
                          color: const Color(0xFF805AD5).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF805AD5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Icon
                      Icon(
                        Icons.favorite,
                        color: statusColor,
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
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${reading.systolic}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _getSystolicColor(reading.systolic),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${reading.diastolic}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _getDiastolicColor(reading.diastolic),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' mmHg',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: statusColor,
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
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    double valueSize = 18,
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
                    fontSize: valueSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                if (unit.isNotEmpty)
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
}

class BPReading {
  final DateTime date;
  final int systolic;
  final int diastolic;
  BPReading(this.date, this.systolic, this.diastolic);
}

List<BPReading> _processReadingsForChart(List<BPReading> rawReadings, int daysRange) {
  if (rawReadings.isEmpty) {
    return [];
  }
  
  // Sort readings by date
  rawReadings.sort((a, b) => a.date.compareTo(b.date));
  
  // Create a map to store readings by date (using day as key)
  final Map<String, List<BPReading>> readingsByDay = {};
  
  // Group readings by day
  for (final reading in rawReadings) {
    final dateKey = DateFormat('yyyy-MM-dd').format(reading.date);
    
    if (readingsByDay.containsKey(dateKey)) {
      readingsByDay[dateKey]!.add(reading);
    } else {
      readingsByDay[dateKey] = [reading];
    }
  }
  
  // Create a list of all dates in the range
  final List<BPReading> processedReadings = [];
  
  // Process each day's readings
  readingsByDay.forEach((date, readings) {
    // If we have multiple readings for a day, include all of them
    processedReadings.addAll(readings);
  });
  
  // Sort the processed readings
  processedReadings.sort((a, b) => a.date.compareTo(b.date));
  
  return processedReadings;
}