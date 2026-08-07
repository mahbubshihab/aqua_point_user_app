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
          body: IndexedStack(
            index: currentIndex,
            children: const [
              HomePage(),
              ServicesHistoryPage(),
              ProductsPage(),
              InboxPage(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0E121E),
              border: Border(
                top: BorderSide(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 60,
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

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<HomeBloc>().add(SelectTab(index));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(height: 3),
              if (isActive)
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
              else
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


