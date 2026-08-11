import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

/// Luxurious Animated Sun/Moon Theme Toggle Button featuring:
/// - Tap spring scale bounce (elasticOut)
/// - 360° rotation animation with easeOutBack curve
/// - Smooth glowing container expansion & color morphing
class AnimatedThemeToggleButton extends StatefulWidget {
  final bool showLabel;
  final EdgeInsetsGeometry padding;

  const AnimatedThemeToggleButton({
    super.key,
    this.showLabel = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  State<AnimatedThemeToggleButton> createState() => _AnimatedThemeToggleButtonState();
}

class _AnimatedThemeToggleButtonState extends State<AnimatedThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap(ThemeProvider themeProvider) async {
    _tapController.forward().then((_) {
      _tapController.reverse();
    });
    themeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final iconColor = isDarkMode ? const Color(0xFFFFB703) : const Color(0xFF0088FF);
        final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleTap(themeProvider),
              borderRadius: BorderRadius.circular(22),
              splashColor: iconColor.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOutCubic,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF0D1B2E).withValues(alpha: 0.88)
                      : Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF00BCE1).withValues(alpha: 0.45)
                        : const Color(0xFF0088FF).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? const Color(0xFF00BCE1).withValues(alpha: 0.3)
                          : const Color(0xFF0088FF).withValues(alpha: 0.22),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 360° Rotating & Morphing Sun/Moon Icon
                    AnimatedRotation(
                      turns: isDarkMode ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 550),
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
                    if (widget.showLabel) ...[
                      const SizedBox(width: 8),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          letterSpacing: 0.3,
                        ),
                        child: Text(isDarkMode ? 'Light' : 'Dark'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
