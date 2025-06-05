import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/charts/chart_symptology.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/charts/charts.dart';
import '../../../../widgets/charts/patient_heatmap.dart';
import '../controllers/patients_detail_controller.dart';

class MeasuresTab extends GetView<PatientsDetailController> {
  const MeasuresTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.offset > 50 && controller.isHeatmapExpanded.value) {
        controller.isHeatmapExpanded.value = false;
      }
    });
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: const Color(0xFFF7FAFC),
          child: SingleChildScrollView(
            controller: scrollController, // Add the scroll controller
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                // Header with title and heatmap toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mediciones de Salud',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      Obx(() => IconButton(
                        icon: Icon(
                          controller.isHeatmapExpanded.value 
                            ? Icons.keyboard_arrow_up 
                            : Icons.keyboard_arrow_down,
                          color: const Color(0xFF4A5568),
                        ),
                        onPressed: () {
                          controller.isHeatmapExpanded.value = !controller.isHeatmapExpanded.value;
                        },
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Heatmap
                Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.isHeatmapExpanded.value ? 176 : 50,
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CollapsiblePatientHeatMap(
                      data: controller.dataList.value,
                    ),
                  ),
                )),
                const SizedBox(height: 20),
                // Main content with tabs and charts - Increased height
                Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  // Adjusted height values to be more moderate
                  height: controller.isHeatmapExpanded.value ? 460 : 580,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vertical tab bar
                      Container(
                        width: constraints.maxWidth * 0.12,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: VerticalTabBar(
                          onTabSelected: (index) {
                            controller.selectedTabIndex.value = index;
                          },
                        ),
                      ),
                      // Chart content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 16, 16),
                          child: Obx(() => _buildTabContent(controller.selectedTabIndex.value)),
                        ),
                      ),
                    ],
                  ),
                )),
                // Add some padding at the bottom for better scrolling experience
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const BloodPressureChart();
      case 1:
        return const HeartRateChart();
      case 2:
        return const BloodOxygenChart();
      case 3:
        return const WeightChart();
      case 4:
        return const MoodChart();
      case 5:
        return const StepsChart();
      case 6:
        return const SymptomatologyList();
      default:
        return const SizedBox.shrink();
    }
  }
}

class VerticalTabBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const VerticalTabBar({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      // Wrap the Column in a SingleChildScrollView to make it scrollable
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Change to min to prevent overflow
          children: [
            _buildTab(
              context,
              0,
              'Presión',
              Icons.favorite_outline,
              const Color(0xFF805AD5),
            ),
            _buildTab(
              context,
              1,
              'Ritmo\nCardíaco',
              Icons.monitor_heart_outlined,
              const Color(0xFFE53E3E),
            ),
            _buildTab(
              context,
              2,
              'Oxígeno',
              Icons.air,
              const Color(0xFF319795),
            ),
            _buildTab(
              context,
              3,
              'Peso',
              Icons.monitor_weight_outlined,
              const Color(0xFF3182CE),
            ),
            _buildTab(
              context,
              4,
              'Estado\nde Ánimo',
              Icons.mood_outlined,
              const Color(0xFFECC94B),
            ),
            _buildTab(
              context,
              5,
              'Pasos',
              Icons.directions_walk,
              const Color(0xFF2B6CB0),
            ),
            _buildTab(
              context,
              6,
              'Síntomas',
              Icons.healing_outlined,
              const Color(0xFFDD6B20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String label, IconData icon, Color activeColor) {
    return Obx(() {
      final isSelected = Get.find<PatientsDetailController>().selectedTabIndex.value == index;
      return InkWell(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? activeColor : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}