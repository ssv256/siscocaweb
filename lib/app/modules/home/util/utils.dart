import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  
  final orderedDays = getOrderedDays();
  final index = value.toInt();
  
  if (index >= 0 && index < orderedDays.length) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(orderedDays[index], style: style),
    );
  }
  
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: const Text('', style: style),
  );
}

List<BarChartGroupData> showingGroups(BuildContext context, List<Map<DateTime, int>> measuresPerDay, RxInt touchedIndex ) {
  final orderedMeasures = orderMeasuresByCurrentDate(measuresPerDay);
  return List.generate(7, (i) {
    double yValue = 0.0;
    if (i < orderedMeasures.length) {
      yValue = orderedMeasures[i].values.first.toDouble();
    }
    return makeGroupData(
      i,
      yValue,
      isTouched: i == touchedIndex.value,
      context: context,
    );
  });
}

BarChartGroupData makeGroupData(
  int x,
  double y, {
  bool isTouched = false,
  Color? barColor,
  double width = 22,
  List<int> showTooltips = const [],
  required BuildContext context,
}) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: isTouched ? y + 1 : y,
        color: Theme.of(context).primaryColor,
        width: width,
        borderSide: const BorderSide(color: Colors.red, width: 0),
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: 20,
          color: Colors.black12,
        ),
      ),
    ],
    showingTooltipIndicators: showTooltips,
  );
}

// Get ordered days with today as the last day
List<String> getOrderedDays() {
  final now = DateTime.now();
  final days = <String>[];
  
  // Start from 7 days ago (i=6) to today (i=0)
  for (int i = 6; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    days.add(getDayLetter(date.weekday));
  }
  
  return days;
}

// Convert weekday to letter
String getDayLetter(int weekday) {
  switch (weekday) {
    case DateTime.monday: return 'L';
    case DateTime.tuesday: return 'M';
    case DateTime.wednesday: return 'X';
    case DateTime.thursday: return 'J';
    case DateTime.friday: return 'V';
    case DateTime.saturday: return 'S';
    case DateTime.sunday: return 'D';
    default: return '';
  }
}

  // Get full day name
  String getFullDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Lunes';
      case DateTime.tuesday: return 'Martes';
      case DateTime.wednesday: return 'Miércoles';
      case DateTime.thursday: return 'Jueves';
      case DateTime.friday: return 'Viernes';
      case DateTime.saturday: return 'Sábado';
      case DateTime.sunday: return 'Domingo';
      default: throw Error();
    }
  }

  List<Map<DateTime, int>> orderMeasuresByCurrentDate(List<Map<DateTime, int>> measuresPerDay) {
    final now = DateTime.now();
    final orderedMeasures = <Map<DateTime, int>>[];
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateWithoutTime = DateTime(date.year, date.month, date.day);
      
      Map<DateTime, int>? foundMeasure;
      for (var measure in measuresPerDay) {
        final measureDate = measure.keys.first;
        if (measureDate.year == dateWithoutTime.year &&
            measureDate.month == dateWithoutTime.month &&
            measureDate.day == dateWithoutTime.day) {
          foundMeasure = measure;
          break;
        }
      }
      
      if (foundMeasure != null) {
        orderedMeasures.add(foundMeasure);
      } else {
        orderedMeasures.add({dateWithoutTime: 0});
      }
    }
    
    return orderedMeasures;
  }
