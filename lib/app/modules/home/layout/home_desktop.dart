import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/card/counter_card.dart';
import '../controllers/home_controller.dart';
import '../widgets/chart_measures_day.dart';
import '../widgets/notifications_home.dart';
import '../widgets/patients_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeDesktop extends GetView<HomeController> {
  HomeDesktop({super.key}) {
    final now = DateTime.now();
    measuresPerDay.addAll([
      {DateTime(now.year, now.month, now.day): 15},
      {DateTime(now.year, now.month, now.day - 1): 8},
      {DateTime(now.year, now.month, now.day - 2): 12},
      {DateTime(now.year, now.month, now.day - 3): 20},
      {DateTime(now.year, now.month, now.day - 4): 7},
      {DateTime(now.year, now.month, now.day - 5): 10},     
      {DateTime(now.year, now.month, now.day - 6): 5}, 
    ]);
  }

  final RxList<Map<DateTime, int>> measuresPerDay = <Map<DateTime, int>>[].obs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 65,
            child: Column(
              children: [
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: CounterCard(
                        title: l10n.totalPatients,
                        data: controller.patients.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CounterCard(
                        title: l10n.alerts,
                        data: controller.totalAlerts.toString(),
                      )
                    ),
                  ],
                )),
                const SizedBox(height: 15),
                PatientsHome(patients: controller.patients),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 35,
            child: Column(
              children: [
                BarChartHome(measuresPerDay: measuresPerDay),
                const SizedBox(height: 20),
                AlertsHome(alerts: controller.alerts),
              ],
            ),
          ),
        ],
      ),
    );
  }
}