import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:siscoca/core/theme/theme.dart';
import '../widget/list_modal.dart';
import '../controller/main_controller.dart';

// Enum para los tipos de feedback
enum FeedbackType { suggestion, bugReport, question }

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late MainController mainController;

  @override
  void initState() {
    super.initState();
    mainController = Get.find<MainController>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorNotifier>(
      builder: (context, colorNotifier, _) {
        final theme = colorNotifier.getTheme(context);
        return Theme(
          data: theme,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                color: colorNotifier.getContainer,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 1300 ? 40.0 : 20.0,
                    vertical: 24.0,
                  ),
                  child: Expanded(
                    child: constraints.maxWidth < 1300
                      ? _buildSingleColumnFAQ()
                      : _buildDoubleColumnFAQ(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAQTile(int index) {
    return Consumer<ColorNotifier>(
      builder: (context, colorNotifier, _) {
        final theme = Theme.of(context);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.cardTheme.color,
            boxShadow: [
              BoxShadow(
                color: theme.cardTheme.shadowColor ?? Colors.transparent,
                blurRadius: colorNotifier.getIsDark ? 8 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding: theme.expansionTileTheme.tilePadding,
            iconColor: theme.expansionTileTheme.iconColor,
            collapsedIconColor: theme.expansionTileTheme.collapsedIconColor,
            shape: theme.expansionTileTheme.shape,
            collapsedShape: theme.expansionTileTheme.collapsedShape,
            backgroundColor: theme.expansionTileTheme.backgroundColor,
            collapsedBackgroundColor: theme.expansionTileTheme.collapsedBackgroundColor,
            title: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.expansionTileTheme.iconColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    modal().faqtitle[index].toString().tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            expandedAlignment: Alignment.centerLeft,
            childrenPadding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  "Our visual branding reflects our commitment to creativity, innovation, and excellence. From our sleek logo to our vibrant color palette and modern typography, every visual element is carefully crafted to convey our brand's personality and values.".tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleColumnFAQ() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFeedbackSection(),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modal().faqtitle.length,
            itemBuilder: (context, index) => _buildFAQTile(index),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubleColumnFAQ() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modal().faqtitle.length,
                    itemBuilder: (context, index) => _buildFAQTile(index),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modal().faqtitle.length,
                    itemBuilder: (context, index) => _buildFAQTile(index),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildFeedbackSection(),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Consumer<ColorNotifier>(
      builder: (context, colorNotifier, _) {
        final theme = Theme.of(context);
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.cardTheme.color,
            boxShadow: [
              BoxShadow(
                color: theme.cardTheme.shadowColor ?? Colors.transparent,
                blurRadius: colorNotifier.getIsDark ? 8 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "¿Tienes sugerencias o encontraste algún problema?".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Comparte tus ideas o reporta cualquier problema técnico que hayas encontrado. Tu opinión es importante para mejorar nuestra plataforma.".tr,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildFeedbackOptions(),
              const SizedBox(height: 24),
              _buildFeedbackForm(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedbackOptions() {
    return Consumer<ColorNotifier>(
      builder: (context, colorNotifier, _) {
        final theme = Theme.of(context);
        
        return Row(
          children: [
            _buildFeedbackOption(
              theme,
              icon: Icons.tips_and_updates_outlined,
              title: "Sugerencia".tr,
              subtitle: "Ideas para mejorar".tr,
              color: theme.colorScheme.primary,
              onTap: () => _showFeedbackDialog(context, FeedbackType.suggestion),
            ),
            const SizedBox(width: 16),
            _buildFeedbackOption(
              theme,
              icon: Icons.bug_report_outlined,
              title: "Problema técnico".tr,
              subtitle: "Reportar un error".tr,
              color: theme.colorScheme.error,
              onTap: () => _showFeedbackDialog(context, FeedbackType.bugReport),
            ),
            const SizedBox(width: 16),
            _buildFeedbackOption(
              theme,
              icon: Icons.question_answer_outlined,
              title: "Pregunta".tr,
              subtitle: "Necesito ayuda".tr,
              color: theme.colorScheme.secondary,
              onTap: () => _showFeedbackDialog(context, FeedbackType.question),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackOption(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Consumer<ColorNotifier>(
      builder: (context, colorNotifier, _) {
        final theme = Theme.of(context);
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Feedback rápido".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Escribe tu mensaje aquí...".tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file_outlined,
                        size: 20,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Adjuntar archivo".tr,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _handleFeedbackSubmission(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Enviar".tr),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context, FeedbackType type) {
    String title = "";
    String description = "";
    IconData icon = Icons.feedback_outlined;
    Color color = Theme.of(context).colorScheme.primary;

    switch (type) {
      case FeedbackType.suggestion:
        title = "Enviar sugerencia".tr;
        description = "Comparte tus ideas para mejorar nuestra plataforma".tr;
        icon = Icons.tips_and_updates_outlined;
        color = Theme.of(context).colorScheme.primary;
        break;
      case FeedbackType.bugReport:
        title = "Reportar problema".tr;
        description = "Cuéntanos sobre cualquier problema técnico que hayas encontrado".tr;
        icon = Icons.bug_report_outlined;
        color = Theme.of(context).colorScheme.error;
        break;
      case FeedbackType.question:
        title = "Hacer una pregunta".tr;
        description = "¿Necesitas ayuda? Estamos aquí para asistirte".tr;
        icon = Icons.question_answer_outlined;
        color = Theme.of(context).colorScheme.secondary;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ColorNotifier>(
          builder: (context, colorNotifier, _) {
            final theme = Theme.of(context);
            final TextEditingController titleController = TextEditingController();
            final TextEditingController descController = TextEditingController();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: color,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Título".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: "Descripción".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      minLines: 4,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          "* Se adjuntará automáticamente información del sistema para ayudarnos a resolver el problema".tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancelar".tr),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            _handleFeedbackSubmission(
                              context, 
                              title: titleController.text,
                              description: descController.text,
                              type: type
                            );
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text("Enviar".tr),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleFeedbackSubmission(BuildContext context, {String? title, String? description, FeedbackType? type}) {
    final feedbackType = type != null ? type.toString().split('.').last : "feedback";
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Gracias por tu $feedbackType. Lo hemos recibido y lo revisaremos pronto.".tr,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}