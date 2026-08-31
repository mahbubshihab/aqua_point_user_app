import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';

class WaterReminderPage extends StatefulWidget {
  const WaterReminderPage({super.key});

  @override
  State<WaterReminderPage> createState() => _WaterReminderPageState();
}

class _WaterReminderPageState extends State<WaterReminderPage> {
  int _consumedMl = 1750;
  int _targetMl = 2500;
  final int _streakDays = 5;
  bool _remindersEnabled = true;
  int _reminderIntervalHours = 1;

  final List<Map<String, String>> _todayLogs = [
    {'time': '08:30 AM', 'amount': '250 ml', 'label': 'Morning Glass'},
    {'time': '10:15 AM', 'amount': '500 ml', 'label': 'Water Bottle'},
    {'time': '01:00 PM', 'amount': '250 ml', 'label': 'Post Lunch'},
    {'time': '03:45 PM', 'amount': '500 ml', 'label': 'Workstation Bottle'},
    {'time': '05:20 PM', 'amount': '250 ml', 'label': 'Evening Refresh'},
  ];

  void _addWater(int amount, String label) {
    setState(() {
      _consumedMl += amount;
      final now = TimeOfDay.now();
      final timeStr = now.format(context);
      _todayLogs.insert(0, {
        'time': timeStr,
        'amount': '$amount ml',
        'label': label,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $amount ml of water! Stay hydrated 💧',
          style: GoogleFonts.inter(),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetToday() {
    setState(() {
      _consumedMl = 0;
      _todayLogs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_consumedMl / _targetMl).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Water Hydration & Reminder',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: _resetToday,
            tooltip: 'Reset Today\'s Water Intake',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.medium,
              ),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 32)),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_streakDays Days Hydration Streak!',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Keep up the great work to boost your health & energy.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Progress Circular Display Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.soft,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 16,
                          backgroundColor: AppColors.background,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            color: AppColors.primary,
                            size: 36,
                          ),
                          const Gap(4),
                          Text(
                            '$percentage%',
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$_consumedMl / $_targetMl ml',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(32),

                  // Quick Log Water Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _QuickAddButton(
                        label: '+ 250ml',
                        icon: Icons.local_drink_rounded,
                        color: AppColors.primary,
                        onTap: () => _addWater(250, 'Glass of Water'),
                      ),
                      _QuickAddButton(
                        label: '+ 500ml',
                        icon: Icons.water_damage_rounded,
                        color: AppColors.success,
                        onTap: () => _addWater(500, 'Water Bottle'),
                      ),
                      _QuickAddButton(
                        label: '+ 100ml',
                        icon: Icons.opacity_rounded,
                        color: const Color(0xFFA855F7),
                        onTap: () => _addWater(100, 'Quick Sip'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Daily Target Selector Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Hydration Target',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Recommended: 2,500 ml for adults',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_targetMl > 1000) {
                              setState(() => _targetMl -= 250);
                            }
                          },
                        ),
                        Text(
                          '$_targetMl ml',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_targetMl < 5000) {
                              setState(() => _targetMl += 250);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Reminder Notification Settings
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: AppColors.warning,
                              size: 20,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            'Hydration Reminders',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _remindersEnabled,
                        activeTrackColor: AppColors.primary,
                        activeThumbColor: Colors.white,
                        onChanged: (val) {
                          setState(() => _remindersEnabled = val);
                        },
                      ),
                    ],
                  ),
                  if (_remindersEnabled) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    Text(
                      'Notification Interval',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(12),
                    Row(
                      children: [1, 2, 3].map((hours) {
                        final isSelected = _reminderIntervalHours == hours;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _reminderIntervalHours = hours);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Every $hours hr${hours > 1 ? 's' : ''}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(24),

            // Today's Intake History List
            Text(
              'Today\'s Water Logs',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(16),

            if (_todayLogs.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    'No water logged yet today.\nTap +250ml above to start!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _todayLogs.length,
                itemBuilder: (context, index) {
                  final log = _todayLogs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['label']!,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                ),
                              ),
                              const Gap(2),
                              Text(
                                log['time']!,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          log['amount']!,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const Gap(32),
          ],
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const Gap(8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
