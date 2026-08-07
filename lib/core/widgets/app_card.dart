import 'package:flutter/material.dart';
import 'glass_card.dart';

/// Styled Glassmorphic Card Container.
/// Delegates to GlassCard for true glassmorphism styling across the application.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      fillColor: backgroundColor ?? const Color(0x1F1A2236),
      borderColor: borderColor ?? const Color(0x2B00E5FF),
      boxShadow: boxShadow,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }
}
