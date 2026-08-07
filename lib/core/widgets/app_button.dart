import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonType {
  primary,
  secondary,
  outlined,
  ghost,
}

/// Customizable button with primary, secondary, outlined, and ghost variants.
/// Supports loading indicator state and custom icons.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final Widget? iconWidget;
  final bool isFullWidth;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.iconWidget,
    this.isFullWidth = true,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16.0,
  });

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconWidget,
    this.isFullWidth = true,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16.0,
  }) : type = AppButtonType.secondary;

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconWidget,
    this.isFullWidth = true,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16.0,
  }) : type = AppButtonType.outlined;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    Color fillBgColor;
    Color borderBgColor = Colors.transparent;
    Color effectiveTextColor;

    switch (type) {
      case AppButtonType.primary:
        fillBgColor = backgroundColor ?? AppColors.primary;
        effectiveTextColor = textColor ?? AppColors.textPrimary;
        break;
      case AppButtonType.secondary:
        fillBgColor = backgroundColor ?? AppColors.secondary.withValues(alpha: 0.15);
        effectiveTextColor = textColor ?? AppColors.secondary;
        break;
      case AppButtonType.outlined:
        fillBgColor = backgroundColor ?? Colors.transparent;
        borderBgColor = AppColors.primary;
        effectiveTextColor = textColor ?? AppColors.primary;
        break;
      case AppButtonType.ghost:
        fillBgColor = backgroundColor ?? Colors.transparent;
        effectiveTextColor = textColor ?? AppColors.textSecondary;
        break;
    }

    if (isDisabled && type == AppButtonType.primary) {
      fillBgColor = fillBgColor.withValues(alpha: 0.5);
    }

    Widget content;
    if (isLoading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
        ),
      );
    } else {
      final List<Widget> children = [];

      if (iconWidget != null) {
        children.add(iconWidget!);
        children.add(const SizedBox(width: 8));
      } else if (icon != null) {
        children.add(Icon(icon, size: 20, color: effectiveTextColor));
        children.add(const SizedBox(width: 8));
      }

      children.add(
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: effectiveTextColor,
          ),
        ),
      );

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    Widget buttonWidget = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fillBgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderBgColor != Colors.transparent
                ? Border.all(color: borderBgColor, width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    if (isFullWidth) {
      buttonWidget = SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
