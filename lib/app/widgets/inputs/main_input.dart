import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../modals/help_modal.dart';
import 'package:toastification/toastification.dart';

class TextFieldWidget extends StatefulWidget {
  final String? id;
  final TextEditingController controller;
  final String title;
  final String labelText;
  final dynamic titleStyle;
  final dynamic textStyle;
  final dynamic background;
  final TextInputType keyboardType;
  final ValueChanged<String>? onchange;
  final bool required;
  final bool obscureText;
  final bool showPassword;
  final bool enable;
  final String hintText;
  final int? maxLines;
  final double? minHeight;
  final double? maxHeight;
  final int? maxLength;
  final double radius;
  final bool border;
  final String? Function(String?)? validate;
  final Function()? onTap;
  final bool margin;
  final dynamic onSubmitted;
  final dynamic focusNode;
  final bool titleMargin;
  final double width;
  final String helpTitle;
  final String helpContent;
  final bool isUrl;
  final bool isEmail;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.id = '',
    this.hintText = '',
    this.title = '',
    this.labelText = '',
    this.onchange,
    this.textStyle = Colors.black,
    this.titleStyle = Colors.black,
    this.background = Colors.white,
    this.required = false,
    this.obscureText = false,
    this.showPassword = true,
    this.enable = true,
    this.maxLines,
    this.minHeight = 40.0,
    this.maxHeight = 150.0,
    this.radius = 7.0,
    this.border = true,
    this.keyboardType = TextInputType.text,
    this.validate,
    this.maxLength,
    this.onTap,
    this.margin = true,
    this.onSubmitted,
    this.focusNode,
    this.titleMargin = true,
    this.width = double.infinity,
    this.helpTitle = '',
    this.helpContent = '',
    this.isUrl = false,
    this.isEmail = false,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  // ignore: unused_field
  late final TextFieldWidgetController _controller;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    final stableId = widget.id ?? widget.controller.hashCode.toString();
    _controller = Get.put(
      TextFieldWidgetController(),
      tag: stableId,
    );
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      final stableId = widget.id ?? widget.controller.hashCode.toString();
      try {
        if (Get.isRegistered<TextFieldWidgetController>(tag: stableId)) {
          Get.delete<TextFieldWidgetController>(tag: stableId);
        }
      } catch (e) {
        debugPrint('Error disposing TextFieldWidgetController: $e');
      }
    }
    super.dispose();
  }

  String? _validateField(String? value) {
    // If there's a custom validation function, use it first
    if (widget.validate != null) {
      return widget.validate!(value);
    }

    // Check for required fields
    if (widget.required && (value == null || value.isEmpty)) {
      _showToast('Please fill in ${widget.labelText.isNotEmpty ? widget.labelText : 'this field'}');
      return 'Required field';
    }

    // Check for valid email format
    if (widget.isEmail && value != null && value.isNotEmpty) {
      var emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
      bool isValid = RegExp(emailPattern, caseSensitive: false).hasMatch(value);
      if (!isValid) {
        _showToast('Por favor ingrese un email válido');
        return 'Email inválido';
      }
    }

    // Check for valid URL format
    if (widget.isUrl && value != null && value.isNotEmpty) {
      var urlPattern = r'^(https?|ftp)://[^\s/$.?#].[^\s]*$';
      bool isValid = RegExp(urlPattern, caseSensitive: false).hasMatch(value);
      if (!isValid) {
        _showToast('Por favor ingrese una URL válida');
        return 'URL inválida';
      }
    }

    return null;
  }

  void _showToast(String message) {
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.warning_2),
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stableId = widget.id ?? widget.controller.hashCode.toString();
    final node = FocusScope.of(context);
    final effectiveMaxLines = widget.obscureText ? 1 : widget.maxLines;

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.title.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: widget.titleMargin ? const EdgeInsets.only(top: 15) : EdgeInsets.zero,
                  child: Text(widget.title, style: TextStyle(color: widget.titleStyle))
                ),
                const SizedBox(width: 15),
                if(widget.helpTitle.isNotEmpty)
                  HelpInformation(
                    title: widget.helpTitle,
                    body: widget.helpContent
                  )
              ],
            ),
          Stack(
            children: [
              Container(
                margin: widget.margin ? EdgeInsets.only(top: widget.title.isEmpty ? 10 : 7) : EdgeInsets.zero,
                constraints: BoxConstraints(
                  minHeight: widget.minHeight ?? 40.0,
                  maxHeight: widget.obscureText ? (widget.minHeight ?? 40.0) : (widget.maxHeight ?? 150.0),
                ),
                child: GetBuilder<TextFieldWidgetController>(
                    tag: stableId,
                    builder: (ctrl) => TextFormField(
                    focusNode: widget.focusNode,
                    inputFormatters: [if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength)],
                    onTap: widget.onTap,
                    onChanged: (value) {
                      if (widget.onchange != null) widget.onchange!(value);
                    },
                    keyboardType: widget.keyboardType,
                    enabled: widget.enable,
                    maxLines: effectiveMaxLines,
                    minLines: widget.obscureText ? 1 : null,
                    controller: widget.controller,
                    obscureText: widget.obscureText && ctrl.isPasswordHidden,
                    decoration: InputDecoration(
                      errorText: null,
                      errorStyle: const TextStyle(height: 0),
                      isDense: true,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
                      fillColor: widget.background,
                      filled: true,
                      labelText: widget.labelText,
                      labelStyle: TextStyle(color: widget.textStyle),
                      hintText: widget.hintText,
                      alignLabelWithHint: true,
                      border: widget.border ? InputBorder.none : null,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                        borderSide: BorderSide(color: widget.border ? Colors.black : Colors.transparent, width: .5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                        borderSide: BorderSide(color: widget.border ? Colors.black54 : Colors.transparent, width: .5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                        borderSide: BorderSide(color: widget.border ? Colors.black : Colors.transparent, width: .5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                        borderSide: BorderSide(color: widget.border ? Colors.red : Colors.transparent, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                        borderSide: BorderSide(color: widget.border ? Colors.black : Colors.transparent, width: .5),
                      )
                    ),
                    validator: _validateField,
                    style: Get.textTheme.bodyMedium!.copyWith(color: widget.textStyle),
                    onEditingComplete: () => node.nextFocus(),
                    onFieldSubmitted: widget.onSubmitted,
                    expands: false,
                  ),
                )
              ),
              if (widget.showPassword && widget.obscureText)
                GetBuilder<TextFieldWidgetController>(
                  tag: stableId,
                  builder: (ctrl) => Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 11, right: 10),
                      child: InkWell(
                        onTap: () => ctrl.togglePasswordVisibility(),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            ctrl.isPasswordHidden ? Icons.visibility_off_rounded : Icons.remove_red_eye,
                            color: Colors.black,
                          ),
                        ),
                      )
                    )
                  )
                )
            ]
          )
        ]
      )
    );
  }
}

class TextFieldWidgetController extends GetxController {
  // Rename to make the meaning clear - true means password is hidden
  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;
  
  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    update();
  }
}