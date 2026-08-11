import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Badge widget with custom color and rounded pill shape.
/// Updated for light theme.
class StatBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Widget? iconWidget;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final Border? border;

  const StatBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconWidget,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.fontSize = 11.0,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 20.0,
    this.border,
  });

  /// Preset for Excellent / Success badge (Green)
  factory StatBadge.excellent({
    Key? key,
    String text = 'EXCELLENT',
    IconData? icon = Icons.check_circle_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.successLight,
      textColor: AppColors.success,
      icon: icon,
    );
  }

  /// Preset for Info badge (Blue)
  factory StatBadge.info({
    Key? key,
    required String text,
    IconData? icon = Icons.water_drop_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.primaryLight,
      textColor: AppColors.primary,
      icon: icon,
    );
  }

  /// Preset for Warning badge (Amber)
  factory StatBadge.warning({
    Key? key,
    required String text,
    IconData? icon = Icons.warning_amber_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.warningLight,
      textColor: AppColors.warning,
      icon: icon,
    );
  }

  /// Preset for Error badge (Red)
  factory StatBadge.error({
    Key? key,
    required String text,
    IconData? icon = Icons.error_outline_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.errorLight,
      textColor: AppColors.error,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor =
        backgroundColor ?? AppColors.primaryLight;
    final effectiveTextColor = textColor ?? AppColors.primary;

    final List<Widget> children = [];

    if (iconWidget != null) {
      children.add(iconWidget!);
      children.add(const SizedBox(width: 4));
    } else if (icon != null) {
      children.add(Icon(icon, size: fontSize + 3, color: effectiveTextColor));
      children.add(const SizedBox(width: 4));
    }

    children.add(
      Text(
        text,
        style: GoogleFonts.inter(
          color: effectiveTextColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.3,
        ),
      ),
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
