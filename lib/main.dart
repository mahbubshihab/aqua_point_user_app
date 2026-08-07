import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_button.dart';
import 'core/widgets/app_card.dart';
import 'core/widgets/app_text_field.dart';
import 'core/widgets/stat_badge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const CoreDesignDemoPage(),
    );
  }
}

class CoreDesignDemoPage extends StatelessWidget {
  const CoreDesignDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appFullName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Core Design System Demo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatBadge.excellent(),
                const SizedBox(width: 10),
                StatBadge.reward(text: '${AppConstants.sampleRewardPoints} PTS'),
                const SizedBox(width: 10),
                StatBadge.info(text: '0/8 Glasses'),
              ],
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Water Quality Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      StatBadge.excellent(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'TDS Level: ${AppConstants.defaultTdsValue} PPM',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const AppTextField(
              label: 'Search Location or Station',
              hintText: 'Enter station name...',
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'Primary Action',
              icon: Icons.water_drop_outlined,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            AppButton.secondary(
              text: 'Secondary Action',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
