import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
        const Text(
          'Services & Features',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            final item = list[index];
            return InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 20, color: item.color),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
