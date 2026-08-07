import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
            iconColor: AppColors.primary,
            secondaryColor: AppColors.secondary,
          ),
          const QuickActionItem(
            label: 'Buy Parts',
            icon: Icons.shopping_bag_outlined,
            iconColor: AppColors.accentGreen,
            secondaryColor: AppColors.accentCyan,
          ),
          const QuickActionItem(
            label: 'Invoices',
            icon: Icons.receipt_long_outlined,
            iconColor: AppColors.accentGold,
            secondaryColor: Color(0xFFF97316),
          ),
          const QuickActionItem(
            label: 'Support',
            icon: Icons.headset_mic_outlined,
            iconColor: Color(0xFFEC4899),
            secondaryColor: AppColors.secondary,
          ),
        ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actionItems.map((item) {
        final secColor = item.secondaryColor ?? item.iconColor.withValues(alpha: 0.6);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.divider,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dual-tone Gradient Glowing Icon Circle
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              item.iconColor.withValues(alpha: 0.25),
                              secColor.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: item.iconColor.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: item.iconColor.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


