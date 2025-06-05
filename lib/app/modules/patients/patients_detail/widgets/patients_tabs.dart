import 'package:flutter/material.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/index.dart';
import 'package:siscoca/app/widgets/card/v1/card/main_card.dart';
import 'patient_measures_tab.dart';
import 'patient_passport_tab.dart';
import 'alerts/patient_alerts_tab_widget.dart';

class PatientsTabs extends StatelessWidget {
  static const double _tabFontSize = 13.0;
  const PatientsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return MainCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      width: MediaQuery.of(context).size.width * 0.94,
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildTabBar(context),
            const SizedBox(height: 8),
            const Expanded(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  MeasuresTab(),
                  PatientAlertsTabWidget(),
                  SurveyRespondeListDesktop(),
                  PatientPassportTab(),               
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return SizedBox(
      height: 36,
      child: TabBar(
        dividerHeight: 0,
        indicator: DotIndicator(
          color: primaryColor,
          radius: 3,
        ),
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: const TextStyle(
          fontSize: _tabFontSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: _tabFontSize,
          fontWeight: FontWeight.w500,
        ),
        splashFactory: NoSplash.splashFactory,
        padding: EdgeInsets.zero,
        tabs: [
          _buildTab(Icons.monitor_heart_outlined, 'Mediciones'),
          _buildTab(Icons.notifications_outlined, 'Alertas'),
          _buildTab(Icons.assignment_outlined, 'Cuestionarios'),
          _buildTab(Icons.badge_outlined, 'Pasaporte'),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class DotIndicator extends Decoration {
  final Color color;
  final double radius;
  
  const DotIndicator({
    required this.color,
    this.radius = 3.0,
  });
  
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(
      color: color,
      radius: radius,
    );
  }
}

class _DotPainter extends BoxPainter {
  final Color color;
  final double radius;
  
  _DotPainter({
    required this.color,
    required this.radius,
  });
  
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(rect.center.dx, rect.bottom - radius - 2),
      radius,
      paint,
    );
  }
}