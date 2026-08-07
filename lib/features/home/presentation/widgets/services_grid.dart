import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class ServiceTileData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ServiceTileData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class ServicesGrid extends StatelessWidget {
  final List<ServiceTileData>? services;

  const ServicesGrid({
    super.key,
    this.services,
  });

  @override
  Widget build(BuildContext context) {
    final list = services ??
        [
          const ServiceTileData(
            title: 'Schedule Service',
            description: 'Filter replacement & maintenance',
            icon: Icons.calendar_month_outlined,
            color: AppColors.primary,
          ),
          const ServiceTileData(
            title: 'Water Reminder',
            description: 'Stay hydrated with alerts',
            icon: Icons.alarm_rounded,
            color: AppColors.accentGreen,
          ),
          const ServiceTileData(
            title: 'Store Locator',
            description: 'Find nearest Aqua Point branch',
            icon: Icons.location_on_outlined,
            color: AppColors.accentYellow,
          ),
          const ServiceTileData(
            title: 'Transaction History',
            description: 'View orders and bills',
            icon: Icons.history_edu_rounded,
            color: Color(0xFFA855F7),
          ),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Services & Features',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Grid View
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            final item = list[index];
            return GlassCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 16,
              onTap: item.onTap,
              borderColor: item.color.withValues(alpha: 0.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rounded Icon Badge
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: item.color.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(item.icon, size: 20, color: item.color),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
