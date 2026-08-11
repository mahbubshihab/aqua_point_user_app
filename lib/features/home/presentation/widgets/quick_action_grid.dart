import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/chat_conversation_page.dart';
import '../../../products/presentation/pages/shop_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';

class QuickActionItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
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
            label: 'Request Service',
            icon: Icons.build_circle_rounded,
            iconColor: isDark ? const Color(0xFF00BCE1) : const Color(0xFF0284C7),
            gradientColors: isDark
                ? [const Color(0xFF0284C7).withValues(alpha: 0.25), const Color(0xFF00BCE1).withValues(alpha: 0.1)]
                : [const Color(0xFFE0F2FE), const Color(0xFFBAE6FD)],
            onTap: () {
              final servicesBloc = context.read<ServicesBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: servicesBloc,
                    child: const CreateServiceRequestPage(),
                  ),
                ),
              );
            },
          ),
          QuickActionItem(
            label: 'Shop',
            icon: Icons.shopping_bag_rounded,
            iconColor: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
            gradientColors: isDark
                ? [const Color(0xFF059669).withValues(alpha: 0.25), const Color(0xFF10B981).withValues(alpha: 0.1)]
                : [const Color(0xFFD1FAE5), const Color(0xFFA7F3D0)],
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
            label: 'Support',
            icon: Icons.support_agent_rounded,
            iconColor: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
            gradientColors: isDark
                ? [const Color(0xFF7C3AED).withValues(alpha: 0.25), const Color(0xFFA78BFA).withValues(alpha: 0.1)]
                : [const Color(0xFFEDE9FE), const Color(0xFFDDD6FE)],
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
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.18,
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
    final borderColor = isDark
        ? item.iconColor.withValues(alpha: 0.3)
        : item.iconColor.withValues(alpha: 0.2);

    return AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: item.iconColor.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glowing Icon Badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.iconColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 22,
                  ),
                ),
              ),
              const Gap(6),

              // Compact Minimal Text Label
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
