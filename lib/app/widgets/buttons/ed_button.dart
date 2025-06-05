import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Main application button with practical functions for its use.
/// This button can adapt its width and height to content unless explicitly specified.
/// Includes default padding to prevent text from touching button borders.
class EdButton extends StatelessWidget {
  final double? width;
  final String text;
  final VoidCallback? onTap;
  final Color textColor;
  final Color? bgColor;
  final Color? splashColor;
  final Color? borderColor;
  final double borderRadius;
  final double? height;
  final double? padding;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final IconData? onlyIcon;
  final bool isLoader;
  final bool setStyleText;
  final double fontSize;
  final dynamic textStyle;
  final MainAxisAlignment mainAxisAlignment;

  const EdButton({
    super.key,
    this.onTap,
    this.text = '',
    this.textColor = Colors.black,
    this.bgColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.borderRadius = 10.0,
    this.padding,
    this.height,
    this.width,
    this.isLoader = false,
    this.setStyleText = false,
    this.fontSize = 16.0,
    this.leadingIcon,
    this.textStyle,
    this.trailingIcon,
    this.onlyIcon,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor,
      onTap: onTap,
      child: Container(
        height: height, 
        width: width, 
        padding: EdgeInsets.symmetric(
          horizontal: padding ?? 9.0, 
          vertical: padding ?? 5.0,    
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor!),
        ),
        child: isLoader
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.black),
              ),
            )
          : onlyIcon == null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  if (leadingIcon != null)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Icon(leadingIcon, color: textColor),
                    ),
                  Text(
                    text,
                    style: !setStyleText
                        ? Get.textTheme.headlineSmall!.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          )
                        : textStyle,
                  ),
                  if (trailingIcon != null)
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Icon(trailingIcon, color: textColor),
                    ),
                ],
              )
            : Icon(onlyIcon, color: textColor),
      ),
    );
  }
}