import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/hydration_entity.dart';

class HydrationTrackerWidget extends StatelessWidget {
  final HydrationEntity hydration;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const HydrationTrackerWidget({
    super.key,
    required this.hydration,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final double progressRatio = (hydration.targetGlasses > 0)
        ? (hydration.currentGlasses / hydration.targetGlasses).clamp(0.0, 1.0)
        : 0.0;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      borderRadius: 18,
      fillColor: const Color(0x2A1E3A8A),
      borderColor: const Color(0xFF06B6D4).withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title "Daily Hydration" & Pill Badge "X/8 Glasses"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Daily Hydration',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              // Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${hydration.currentGlasses}/${hydration.targetGlasses} Glasses',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Minimal Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          const SizedBox(height: 10),

          // Interactive Controls Row with Glowing Circular Glass Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progressRatio * 100).toInt()}% Achieved',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              Row(
                children: [
                  // Glowing Glass Decrement Button (-)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: hydration.currentGlasses > 0 ? onDecrement : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hydration.currentGlasses > 0
                              ? Colors.white.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.08),
                          border: Border.all(
                            color: hydration.currentGlasses > 0
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                          boxShadow: hydration.currentGlasses > 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          Icons.remove_rounded,
                          size: 18,
                          color: hydration.currentGlasses > 0
                              ? Colors.white
                              : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Central Count Display
                  Container(
                    constraints: const BoxConstraints(minWidth: 24),
                    alignment: Alignment.center,
                    child: Text(
                      '${hydration.currentGlasses}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Glowing Glass Increment Button (+)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onIncrement,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.25),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
