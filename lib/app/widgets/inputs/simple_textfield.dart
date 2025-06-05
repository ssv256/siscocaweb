import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siscoca/core/theme/theme.dart';

class SimpleTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final int? maxLine;
  final bool enabled;
  final bool isPassword;
  final bool isDisabled;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const SimpleTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.maxLine,
    this.enabled = true,
    this.isPassword = false,
    this.isDisabled = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifire = Provider.of<ColorNotifier>(context, listen: true);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 13),
        TextField(
          controller: controller,
          enabled: enabled && !isDisabled,
          obscureText: isPassword,
          onChanged: onChanged,
          style: TextStyle(
            color: isDisabled 
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : theme.colorScheme.onSurface,
          ),
          maxLines: isPassword ? 1 : maxLine,
          decoration: InputDecoration(
            filled: isDisabled,
            fillColor: isDisabled 
                ? (notifire.getIsDark ? Colors.grey[800] : Colors.grey[200])
                : theme.cardTheme.color,
            hintText: hintText,
            hintStyle: TextStyle(
              height: 1,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: 15,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDisabled 
                    ? Colors.transparent 
                    : theme.colorScheme.onSurface.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDisabled 
                    ? Colors.transparent 
                    : theme.colorScheme.onSurface.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}