import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../domain/entities/water_quality_entity.dart';

class WaterQualityCard extends StatelessWidget {
  final WaterQualityEntity waterQuality;

  const WaterQualityCard({
    super.key,
    required this.waterQuality,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Emerald Green EXCELLENT Pill Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Water Quality',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              StatBadge.excellent(text: waterQuality.status),
            ],
          ),

          const SizedBox(height: 14),

          // Large Electric Cyan TDS Numeric Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${waterQuality.tds}',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'TDS',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3 Minimal Metric Pills: Iron: 0.05, pH: 7.2, Hardness: Low
          Row(
            children: [
              Expanded(
                child: _MinimalMetricPill(
                  label: 'Iron: ${waterQuality.iron}',
                  accentColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MinimalMetricPill(
                  label: 'pH: ${waterQuality.ph}',
                  accentColor: AppColors.accentGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MinimalMetricPill(
                  label: 'Hardness: ${waterQuality.hardness}',
                  accentColor: AppColors.accentGold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MinimalMetricPill extends StatelessWidget {
  final String label;
  final Color accentColor;

  const _MinimalMetricPill({
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}


