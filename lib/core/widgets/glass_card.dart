import 'dart:ui';
import 'package:flutter/material.dart';

/// True Glassmorphism Card Widget
/// Features backdrop blur (12px), semi-transparent fill (Color(0x1F1A2236)),
/// and a subtle glowing cyan border (Color(0x2B00E5FF)).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double blurSigma;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16.0,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.onTap,
    this.width,
    this.height,
    this.blurSigma = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFillColor = fillColor ?? const Color(0x1F1A2236);
    final effectiveBorderColor = borderColor ?? const Color(0x2B00E5FF);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: effectiveBorderColor.withValues(alpha: 0.1),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );

    Widget cardWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: content,
      ),
    );

    if (onTap != null) {
      cardWidget = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardWidget,
        ),
      );
    }

    if (margin != null) {
      cardWidget = Padding(
        padding: margin!,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
