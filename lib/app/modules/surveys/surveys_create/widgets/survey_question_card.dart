import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:research_package/research_package.dart';
import 'package:siscoca/app/modules/surveys/index.dart';
import 'package:siscoca/app/modules/surveys/surveys_create/controllers/ext_survey_create_controller.dart';

class SurveysQuestionCard extends GetView<SurveysCreateController> {
  final RPStep step;
  final int index;
  const SurveysQuestionCard({super.key, required this.step, required this.index});

  Widget questionTypeLabel(String type, {Color? customColor}) {
    final Map<String, Color> typeColors = {
      'Radio': const Color(0xFF4CAF50),
      'Slider': const Color(0xFFE91E63),
      'Numeros': const Color(0xFF9C27B0),
      'Texto': const Color(0xFFF44336),
      'Instrucción': const Color(0xFFFFC107),
      'Completado': const Color(0xFF2196F3),
      'Selección multiple': const Color(0xFF3F51B5),
      'Unica respuesta': const Color(0xFF3F51B5),
    };
    
    Color backgroundColor = customColor ?? 
        (typeColors[type] ?? const Color(0xFF9E9E9E)).withOpacity(0.15);
    Color textColor = customColor ?? 
        (typeColors[type] ?? const Color(0xFF9E9E9E));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        type, 
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.w600,
          color: textColor,
        )
      )
    );
  }

  String getStepType() {
    if (step is RPQuestionStep) {
      final questionStep = step as RPQuestionStep;
      final format = questionStep.answerFormat;
      
      if (format is RPChoiceAnswerFormat) return 'Radio';
      if (format is RPSliderAnswerFormat) return 'Slider';
      if (format is RPDoubleAnswerFormat) return 'Numeros';
      if (format is RPTextAnswerFormat) return 'Texto';
      return 'Desconocido';
    }
    
    return switch(step.runtimeType) {
      RPInstructionStep _ => 'Instrucción',
      RPCompletionStep _ => 'Completado',
      _ => 'Desconocido'
    };
  }

  Widget buildStepContent() {
    if (step is RPQuestionStep) {
      final questionStep = step as RPQuestionStep;
      final format = questionStep.answerFormat;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  questionStep.title, 
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              questionTypeLabel(getStepType()),
              const SizedBox(width: 8),
              if (format is RPChoiceAnswerFormat)
                questionTypeLabel(
                  format.answerStyle == RPChoiceAnswerStyle.MultipleChoice 
                    ? 'Selección multiple' 
                    : 'Unica respuesta',
                ),
            ],
          ),
          if (questionStep.text != null && questionStep.text!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                questionStep.text!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      );
    }
    
    if (step is RPInstructionStep) {
      final instructionStep = step as RPInstructionStep;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  instructionStep.title, 
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          questionTypeLabel('Instrucción'),
          if (instructionStep.text != null && instructionStep.text!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                instructionStep.text!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      );
    }

    if (step is RPCompletionStep) {
      final completionStep = step as RPCompletionStep;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  completionStep.title, 
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          questionTypeLabel('Completado'),
          if (completionStep.text != null && completionStep.text!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                completionStep.text!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget buildOptionsContent(BuildContext context) {
    if (step is RPQuestionStep) {
      final questionStep = step as RPQuestionStep;
      final format = questionStep.answerFormat;

      final optionContent = switch(format.runtimeType) {
        RPChoiceAnswerFormat _ => '${(format as RPChoiceAnswerFormat).choices.length} opciones',
        RPSliderAnswerFormat _ => 'Min: ${(format as RPSliderAnswerFormat).minValue} - Max: ${(format).maxValue}',
        RPDoubleAnswerFormat _ => 'Min: ${(format as RPDoubleAnswerFormat).minValue} - Max: ${(format).maxValue}',
        RPTextAnswerFormat _ => 'Respuesta de texto',
        _ => 'Tipo de respuesta desconocido'
      };

      return Row(
        children: [
          Icon(
            _getFormatIcon(format),
            size: 16,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            optionContent,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (step is RPInstructionStep) {
      return Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            'Paso de instrucciones',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (step is RPCompletionStep) {
      return Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Colors.green.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            'Paso de finalización',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
    
    return const SizedBox();
  }

  IconData _getFormatIcon(dynamic format) {
    return switch(format.runtimeType) {
      RPChoiceAnswerFormat _ => Icons.radio_button_checked,
      RPSliderAnswerFormat _ => Icons.linear_scale,
      RPDoubleAnswerFormat _ => Icons.numbers,
      RPTextAnswerFormat _ => Icons.text_fields,
      _ => Icons.help_outline
    };
  }

  @override
  Widget build(BuildContext context) {
    return _HoverableQuestionCard(
      step: step,
      index: index,
      controller: controller,
      buildStepContent: buildStepContent,
      buildOptionsContent: buildOptionsContent,
      buildNumberAndDragHandle: _buildNumberAndDragHandle,
      buildActionButtons: _buildActionButtons,
    );
  }

  Widget _buildNumberAndDragHandle(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.drag_handle,
              color: Colors.grey[500],
              size: 20,
            ),
          )
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(
          context,
          Icons.edit_outlined,
          Colors.blue,
          'Editar',
          () {
            controller.setStepToEdit(step);
            showDialog(
              context: context,
              builder: (context) {
                if (step is RPInstructionStep) {
                  return const SurveyInstructionModal();
                } else if (step is RPCompletionStep) {
                  return const SurveyCompletionModal();
                } else {
                  return const SurveyQuestionModal();
                }
              }
            );
          }
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          context,
          Icons.delete_outline,
          Colors.red,
          'Eliminar',
          () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Eliminar Pregunta'),
              content: const Text('¿Está seguro de eliminar esta pregunta?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    controller.removeStep(step);
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar')
                )
              ],
            )
          )
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, 
    IconData icon, 
    Color color, 
    String tooltip, 
    VoidCallback onTap
  ) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

// New HoverableQuestionCard class
class _HoverableQuestionCard extends StatefulWidget {
  final RPStep step;
  final int index;
  final SurveysCreateController controller;
  final Widget Function() buildStepContent;
  final Widget Function(BuildContext) buildOptionsContent;
  final Widget Function(BuildContext) buildNumberAndDragHandle;
  final Widget Function(BuildContext) buildActionButtons;

  const _HoverableQuestionCard({
    required this.step,
    required this.index,
    required this.controller,
    required this.buildStepContent,
    required this.buildOptionsContent,
    required this.buildNumberAndDragHandle,
    required this.buildActionButtons,
  });

  @override
  State<_HoverableQuestionCard> createState() => _HoverableQuestionCardState();
}

class _HoverableQuestionCardState extends State<_HoverableQuestionCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHovered 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3) 
              : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
              blurRadius: isHovered ? 8 : 5,
              spreadRadius: isHovered ? 1 : 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            onTap: () {
              widget.controller.setStepToEdit(widget.step);
              showDialog(
                context: context,
                builder: (context) {
                  if (widget.step is RPInstructionStep) {
                    return const SurveyInstructionModal();
                  } else if (widget.step is RPCompletionStep) {
                    return const SurveyCompletionModal();
                  } else {
                    return const SurveyQuestionModal();
                  }
                }
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.buildNumberAndDragHandle(context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.buildStepContent(),
                        const Divider(height: 24),
                        Row(
                          children: [
                            widget.buildOptionsContent(context),
                            const Spacer(),
                            widget.buildActionButtons(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
