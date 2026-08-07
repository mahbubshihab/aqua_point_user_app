import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

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
        content: Text('Added $amount ml of water! Stay hydrated 💧'),
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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Water Hydration & Reminder',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: _resetToday,
            tooltip: 'Reset Today\'s Water Intake',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x403B82F6),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 26),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_streakDays Days Hydration Streak!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(2),
                        const Text(
                          'Keep up the great work to boost your health & energy.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Progress Circular Display Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 14,
                          backgroundColor: AppColors.inputFill,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          const Gap(4),
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$_consumedMl / $_targetMl ml',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(20),

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
                        color: AppColors.accentGreen,
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
            const Gap(16),

            // Daily Target Selector Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Daily Hydration Target',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Gap(2),
                      Text(
                        'Recommended: 2,500 ml for adults',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                        onPressed: () {
                          if (_targetMl > 1000) {
                            setState(() => _targetMl -= 250);
                          }
                        },
                      ),
                      Text(
                        '$_targetMl ml',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        onPressed: () {
                          if (_targetMl < 5000) {
                            setState(() => _targetMl += 250);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Reminder Notification Settings
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.notifications_active_rounded, color: AppColors.accentGold, size: 20),
                          Gap(8),
                          Text(
                            'Hydration Reminders',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _remindersEnabled,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _remindersEnabled = val);
                        },
                      ),
                    ],
                  ),
                  if (_remindersEnabled) ...[
                    const Divider(color: AppColors.divider, height: 20),
                    const Text(
                      'Notification Interval',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.inputFill,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.cardBorder,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Every $hours hr${hours > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
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
            const Gap(16),

            // Today's Intake History List
            const Text(
              'Today\'s Water Intake Logs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),

            if (_todayLogs.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No water logged yet today. Tap +250ml above to start!',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['label']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                log['time']!,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          log['amount']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const Gap(24),
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const Gap(4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
