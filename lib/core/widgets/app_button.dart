import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';

enum AppButtonType {
  primary,
  secondary,
  outlined,
  ghost,
}

/// Premium button with gradient primary, clean secondary, outlined, and ghost variants.
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
    this.fontSize = 15.0,
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
    this.fontSize = 15.0,
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
    this.fontSize = 15.0,
  }) : type = AppButtonType.outlined;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    Color fillBgColor;
    Color borderBgColor = Colors.transparent;
    Color effectiveTextColor;
    List<BoxShadow>? shadow;
    Gradient? gradient;

    switch (type) {
      case AppButtonType.primary:
        fillBgColor = backgroundColor ?? AppColors.primary;
        effectiveTextColor = textColor ?? AppColors.textOnPrimary;
        gradient = backgroundColor == null ? AppGradients.primary : null;
        shadow = isDisabled ? null : AppShadows.colored(AppColors.primary);
        break;
      case AppButtonType.secondary:
        fillBgColor = backgroundColor ?? AppColors.primaryLight;
        effectiveTextColor = textColor ?? AppColors.primary;
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
      gradient = null;
      fillBgColor = fillBgColor.withValues(alpha: 0.5);
      shadow = null;
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
          style: GoogleFonts.inter(
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
        splashColor: effectiveTextColor.withValues(alpha: 0.1),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: gradient == null ? fillBgColor : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderBgColor != Colors.transparent
                ? Border.all(color: borderBgColor, width: 1.5)
                : null,
            boxShadow: shadow,
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
