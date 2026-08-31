import 'package:flutter/material.dart';

/// AnimatedThemeToggleButton - Disabled for Pure White Theme.
/// Returns an empty SizedBox.shrink() so no theme toggle button renders anywhere.
class AnimatedThemeToggleButton extends StatelessWidget {
  final bool showLabel;
  final EdgeInsetsGeometry padding;

  const AnimatedThemeToggleButton({
    super.key,
    this.showLabel = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

