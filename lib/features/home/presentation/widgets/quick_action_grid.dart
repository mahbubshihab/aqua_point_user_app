import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickActionItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.iconColor,
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
            label: 'Request\nService',
            icon: Icons.build_circle_outlined,
            iconColor: Color(0xFF3B82F6),
          ),
          const QuickActionItem(
            label: 'Buy\nParts',
            icon: Icons.shopping_bag_outlined,
            iconColor: Color(0xFF10B981),
          ),
          const QuickActionItem(
            label: 'Invoices',
            icon: Icons.receipt_long_outlined,
            iconColor: Color(0xFFF59E0B),
          ),
          const QuickActionItem(
            label: 'Support',
            icon: Icons.headset_mic_outlined,
            iconColor: Color(0xFFEC4899),
          ),
        ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actionItems.map((item) {
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
                      color: AppColors.cardBorder,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dual-tone Icon Background Badge
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.iconColor.withValues(alpha: 0.12),
                          border: Border.all(
                            color: item.iconColor.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: item.iconColor.withValues(alpha: 0.1),
                              blurRadius: 6,
                              spreadRadius: 0,
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
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.25,
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

