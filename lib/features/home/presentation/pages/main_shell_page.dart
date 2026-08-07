import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/inbox_page.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../services/presentation/pages/services_history_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'home_page.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final currentIndex = (state is HomeLoaded) ? state.tabIndex : 0;

        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: const [
              HomePage(),
              ServicesHistoryPage(),
              ProductsPage(),
              InboxPage(),
            ],
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xF00D111D),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(
                      color: Color(0x3300E5FF),
                      width: 1.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 64,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavBarItem(
                          index: 0,
                          currentIndex: currentIndex,
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home_rounded,
                          label: 'Home',
                        ),
                        _NavBarItem(
                          index: 1,
                          currentIndex: currentIndex,
                          icon: Icons.history_outlined,
                          activeIcon: Icons.history_rounded,
                          label: 'History',
                        ),
                        _NavBarItem(
                          index: 2,
                          currentIndex: currentIndex,
                          icon: Icons.water_drop_outlined,
                          activeIcon: Icons.water_drop_rounded,
                          label: 'Products',
                        ),
                        _NavBarItem(
                          index: 3,
                          currentIndex: currentIndex,
                          icon: Icons.inbox_outlined,
                          activeIcon: Icons.inbox_rounded,
                          label: 'Inbox',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    const activeColor = Color(0xFF00E5FF);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<HomeBloc>().add(SelectTab(index));
          },
          splashColor: activeColor.withValues(alpha: 0.1),
          highlightColor: activeColor.withValues(alpha: 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 4),
                height: 3,
                width: isActive ? 16 : 0,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: activeColor,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              AnimatedScale(
                scale: isActive ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? activeColor : AppColors.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? activeColor : AppColors.textSecondary,
                  shadows: isActive
                      ? const [
                          Shadow(
                            color: Color(0x6600E5FF),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



