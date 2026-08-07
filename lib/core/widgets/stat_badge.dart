import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge widget (e.g. "EXCELLENT", "0/8 Glasses") with custom color and rounded pill shape.
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
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.bold,
    this.borderRadius = 20.0,
    this.border,
  });

  /// Preset for Excellent Water Quality badge (Green)
  factory StatBadge.excellent({
    Key? key,
    String text = 'EXCELLENT',
    IconData? icon = Icons.check_circle_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.accentGreen.withValues(alpha: 0.15),
      textColor: AppColors.accentGreen,
      icon: icon,
      border: Border.all(
        color: AppColors.accentGreen.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  /// Preset for Reward Points badge (Yellow / Star)
  factory StatBadge.reward({
    Key? key,
    required String text,
    IconData? icon = Icons.star_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.accentYellow.withValues(alpha: 0.15),
      textColor: AppColors.accentYellow,
      icon: icon,
      border: Border.all(
        color: AppColors.accentYellow.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  /// Preset for Hydration or Info badge (Blue)
  factory StatBadge.info({
    Key? key,
    required String text,
    IconData? icon = Icons.water_drop_rounded,
  }) {
    return StatBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      textColor: AppColors.secondary,
      icon: icon,
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor =
        backgroundColor ?? AppColors.primary.withValues(alpha: 0.15);
    final effectiveTextColor = textColor ?? AppColors.textPrimary;

    final List<Widget> children = [];

    if (iconWidget != null) {
      children.add(iconWidget!);
      children.add(const SizedBox(width: 4));
    } else if (icon != null) {
      children.add(Icon(icon, size: fontSize + 2, color: effectiveTextColor));
      children.add(const SizedBox(width: 4));
    }

    children.add(
      Text(
        text,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.5,
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
