import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/chat_conversation_page.dart';
import '../../../products/presentation/pages/shop_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';
import '../../../tools/presentation/pages/water_reminder_page.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final actionItems = items ??
        [
          QuickActionItem(
            label: 'Book Service',
            icon: Icons.home_repair_service_rounded,
            iconColor: isDark ? const Color(0xFF00BCE1) : AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ServicesBloc>(),
                    child: const CreateServiceRequestPage(),
                  ),
                ),
              );
            },
          ),
          QuickActionItem(
            label: 'Shop',
            icon: Icons.shopping_bag_rounded,
            iconColor: isDark ? const Color(0xFF10B981) : AppColors.success,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShopPage(),
                ),
              );
            },
          ),
          QuickActionItem(
            label: 'Water Reminder',
            icon: Icons.alarm_rounded,
            iconColor: isDark ? const Color(0xFFF59E0B) : AppColors.warning,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WaterReminderPage(),
                ),
              );
            },
          ),
          QuickActionItem(
            label: 'Support',
            icon: Icons.support_agent_rounded,
            iconColor: isDark ? const Color(0xFF3B82F6) : AppColors.secondary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatConversationPage(),
                ),
              );
            },
          ),
        ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.82,
      children: actionItems.map((item) {
        return QuickActionTile(item: item);
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (item.onTap != null) {
            item.onTap!();
          }
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: isDark ? 0.18 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: textColorPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
