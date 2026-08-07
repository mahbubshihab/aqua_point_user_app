import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class QuickActionItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color? secondaryColor;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.secondaryColor,
    this.onTap,
  });
}

class QuickActionGrid extends StatelessWidget {
  final List<QuickActionItem>? items;

  const QuickActionGrid({
    super.key,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final actionItems = items ??
        [
          const QuickActionItem(
            label: 'Request Service',
            icon: Icons.build_circle_outlined,
            iconColor: Color(0xFF3B82F6), // Electric Blue glow
            secondaryColor: Color(0xFF60A5FA),
          ),
          const QuickActionItem(
            label: 'Buy Parts',
            icon: Icons.shopping_bag_outlined,
            iconColor: Color(0xFF10B981), // Emerald Cyan glow
            secondaryColor: Color(0xFF34D399),
          ),
          const QuickActionItem(
            label: 'Invoices',
            icon: Icons.receipt_long_outlined,
            iconColor: Color(0xFFF59E0B), // Warm Amber Gold glow
            secondaryColor: Color(0xFFFBBF24),
          ),
          const QuickActionItem(
            label: 'Support',
            icon: Icons.headset_mic_outlined,
            iconColor: Color(0xFFEC4899), // Magenta Purple glow
            secondaryColor: Color(0xFFF472B6),
          ),
        ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemPadding = constraints.maxWidth < 360 ? 6.0 : 10.0;
        final double iconSize = constraints.maxWidth < 360 ? 20.0 : 24.0;
        final double iconPadding = constraints.maxWidth < 360 ? 8.0 : 10.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actionItems.map((item) {
            final secColor = item.secondaryColor ?? item.iconColor.withValues(alpha: 0.6);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GlassCard(
                  padding: EdgeInsets.symmetric(vertical: itemPadding, horizontal: 4),
                  borderRadius: 14,
                  borderColor: item.iconColor.withValues(alpha: 0.3),
                  fillColor: const Color(0x1F1A2236),
                  onTap: item.onTap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dual-tone Gradient Glowing Icon Circle
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              item.iconColor.withValues(alpha: 0.3),
                              secColor.withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: item.iconColor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: item.iconColor.withValues(alpha: 0.25),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: iconSize,
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.2,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
