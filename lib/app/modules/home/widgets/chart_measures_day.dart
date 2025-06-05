import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/widgets/card/v1/card/main_card.dart';
import '../util/utils.dart';

class BarChartHome extends StatelessWidget {
  final RxList<Map<DateTime, int>> measuresPerDay;
  final touchedIndex = (-1).obs;

  BarChartHome({
    super.key,
    required this.measuresPerDay,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MainCard(
        margin: EdgeInsets.zero,
        width: MediaQuery.of(context).size.width * 0.29,
        height: 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos Registrados',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            Obx(() => SizedBox(
              height: 200,
              child: BarChart(mainBarData(context)),
            )),
          ],
        ),
      ),
    );
  }

  BarChartData mainBarData(BuildContext context) {
    return BarChartData(
      maxY: 20,
      minY: 0,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final now = DateTime.now();
            final date = now.subtract(Duration(days: 6 - group.x.toInt()));
            final weekDay = getFullDayName(date.weekday);
            
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${rod.toY.toInt()} medidas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          if (barTouchResponse?.spot != null) {
            touchedIndex.value = barTouchResponse!.spot!.touchedBarGroupIndex;
          } else {
            touchedIndex.value = -1;
          }
        },
      ),
      titlesData: const  FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(context, measuresPerDay, touchedIndex),
      gridData: const FlGridData(show: false),
    );
  }
}