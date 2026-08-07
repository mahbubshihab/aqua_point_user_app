import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';

class QuickActionItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color? secondaryColor;
  final List<Color>? gradientColors;
  final Color? glowColor;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.secondaryColor,
    this.gradientColors,
    this.glowColor,
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
            icon: Icons.home_repair_service_rounded,
            iconColor: Color(0xFF00E5FF),
            gradientColors: [Color(0xFF1D4ED8), Color(0xFF00E5FF)],
            glowColor: Color(0x5500E5FF),
          ),
          const QuickActionItem(
            label: 'Buy Parts',
            icon: Icons.shopping_bag_rounded,
            iconColor: Color(0xFF10B981),
            gradientColors: [Color(0xFF047857), Color(0xFF10B981)],
            glowColor: Color(0x5510B981),
          ),
          const QuickActionItem(
            label: 'Invoices',
            icon: Icons.receipt_long_rounded,
            iconColor: Color(0xFFF59E0B),
            gradientColors: [Color(0xFFB45309), Color(0xFFF59E0B)],
            glowColor: Color(0x55F59E0B),
          ),
          const QuickActionItem(
            label: 'Support',
            icon: Icons.support_agent_rounded,
            iconColor: Color(0xFFEC4899),
            gradientColors: [Color(0xFFBE185D), Color(0xFFEC4899)],
            glowColor: Color(0x55EC4899),
          ),
        ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: actionItems.map((item) {
        return RepaintBoundary(child: QuickActionTile(item: item));
      }).toList(),
    );
  }
}

class QuickActionTile extends StatefulWidget {
  final QuickActionItem item;

  const QuickActionTile({
    super.key,
    required this.item,
  });

  @override
  State<QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<QuickActionTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final gradientColors = item.gradientColors ??
        [
          item.secondaryColor ?? item.iconColor.withValues(alpha: 0.8),
          item.iconColor,
        ];
    final glowColor = item.glowColor ?? item.iconColor.withValues(alpha: 0.35);

    return AnimatedScale(
      scale: _isPressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (item.onTap != null) {
            item.onTap!();
          } else if (item.label == 'Request Service' || item.label == 'Book Service') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ServicesBloc>(),
                  child: const CreateServiceRequestPage(),
                ),
              ),
            );
          }
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          borderRadius: 14,
          fillColor: const Color(0x1F141A2D),
          borderGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x3300E5FF),
              Color(0x0500E5FF),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 38x38px 3D Glowing Gradient Icon Badge
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 5),
              // Card title 11px (w500)
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
