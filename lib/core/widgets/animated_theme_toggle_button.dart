import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

/// Ultra-smooth animated Sun/Moon Theme Toggle Button with 360° rotation,
/// icon scale transition, and glowing container morphing!
class AnimatedThemeToggleButton extends StatelessWidget {
  final bool showLabel;
  final EdgeInsetsGeometry padding;

  const AnimatedThemeToggleButton({
    super.key,
    this.showLabel = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final iconColor = isDarkMode ? const Color(0xFFFFB703) : const Color(0xFF0088FF);
        final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => themeProvider.toggleTheme(),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: padding,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF0D1B2E).withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFF00BCE1).withValues(alpha: 0.4)
                      : const Color(0xFF0088FF).withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? const Color(0xFF00BCE1).withValues(alpha: 0.25)
                        : const Color(0xFF0088FF).withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Rotating & Morphing Sun/Moon Icon
                  AnimatedRotation(
                    turns: isDarkMode ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: Icon(
                        isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                        key: ValueKey<bool>(isDarkMode),
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                  if (showLabel) ...[
                    const SizedBox(width: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      child: Text(isDarkMode ? 'Light' : 'Dark'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
