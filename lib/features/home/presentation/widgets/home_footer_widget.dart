import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeFooterWidget extends StatelessWidget {
  const HomeFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          'Crafted with ❤️ by AQUA POINT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
