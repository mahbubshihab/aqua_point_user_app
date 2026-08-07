import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../home/domain/entities/water_quality_entity.dart';

typedef WaterQualityDetailPage = TdsMeterPage;

class TdsMeterPage extends StatefulWidget {
  final WaterQualityEntity? waterQuality;

  const TdsMeterPage({
    super.key,
    this.waterQuality,
  });

  @override
  State<TdsMeterPage> createState() => _TdsMeterPageState();
}

class _TdsMeterPageState extends State<TdsMeterPage> {
  late int _tds;
  late double _iron;
  late double _ph;
  late String _hardness;
  late String _status;
  bool _isScanning = false;
  int _healthScore = 98;

  @override
  void initState() {
    super.initState();
    final wq = widget.waterQuality;
    _tds = wq?.tds ?? 45;
    _iron = wq?.iron ?? 0.05;
    _ph = wq?.ph ?? 7.2;
    _hardness = wq?.hardness ?? 'Low';
    _status = wq?.status ?? 'EXCELLENT';
  }

  void _simulateReTest() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _tds = 42 + (DateTime.now().second % 6);
      _iron = 0.04;
      _ph = 7.3;
      _hardness = 'Low';
      _status = 'EXCELLENT';
      _healthScore = 99;
      _isScanning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live Water Analysis complete! Result: 99% Pure 💧'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Live TDS & Water Quality Gauge',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Water Purity Health Score Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3300E5FF),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WATER PURITY HEALTH SCORE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Gap(6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$_healthScore',
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              '/100',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Gap(4),
                        Text(
                          'Grade A+ • Safe & Safe Drinking Water',
                          style: TextStyle(
                            color: AppColors.accentGreen.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatBadge.excellent(text: _status),
                ],
              ),
            ),
            const Gap(16),

            // Live TDS Gauge Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Live TDS Gauge (Total Dissolved Solids)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Icon(Icons.sensors_rounded, color: AppColors.primary, size: 18),
                    ],
                  ),
                  const Gap(20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: (_tds / 300).clamp(0.0, 1.0),
                          strokeWidth: 14,
                          backgroundColor: AppColors.inputFill,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isScanning)
                            const CircularProgressIndicator(color: AppColors.primary)
                          else ...[
                            Text(
                              '$_tds',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              'PPM',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TdsRangeLegend(range: '0 - 50', label: 'Pure (RO)', isCurrent: _tds <= 50),
                      _TdsRangeLegend(range: '51 - 150', label: 'Ideal', isCurrent: _tds > 50 && _tds <= 150),
                      _TdsRangeLegend(range: '151 - 300', label: 'Fair', isCurrent: _tds > 150 && _tds <= 300),
                    ],
                  ),
                  const Gap(16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isScanning ? null : _simulateReTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 18),
                      label: Text(
                        _isScanning ? 'Testing Water Quality...' : 'Re-Test Water Quality',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Detailed Water Parameters Breakdown Grid
            const Text(
              'Chemical & Mineral Breakdown Analysis',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(10),

            Row(
              children: [
                Expanded(
                  child: _MetricDetailCard(
                    title: 'Iron (Fe)',
                    value: '$_iron mg/L',
                    subtitle: 'Safe Limit: < 0.3 mg/L',
                    status: 'Excellent',
                    color: AppColors.primary,
                    icon: Icons.invert_colors_rounded,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _MetricDetailCard(
                    title: 'pH Level',
                    value: '$_ph pH',
                    subtitle: 'Ideal: 6.5 - 8.5 pH',
                    status: 'Optimal Neutral',
                    color: AppColors.accentGreen,
                    icon: Icons.science_rounded,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: _MetricDetailCard(
                    title: 'Hardness',
                    value: _hardness,
                    subtitle: '25 mg/L CaCO3',
                    status: 'Soft Water',
                    color: AppColors.accentGold,
                    icon: Icons.bubble_chart_rounded,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _MetricDetailCard(
                    title: 'Chlorine',
                    value: '0.01 mg/L',
                    subtitle: 'Filtered Out',
                    status: 'Pure',
                    color: const Color(0xFFA855F7),
                    icon: Icons.shield_rounded,
                  ),
                ),
              ],
            ),
            const Gap(16),

            // RO Membrane & Filter Health Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'RO Filter Health Status',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '92% Good Condition',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const LinearProgressIndicator(
                      value: 0.92,
                      minHeight: 8,
                      backgroundColor: AppColors.inputFill,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    'Next scheduled filter maintenance in approximately 114 days.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}

class _TdsRangeLegend extends StatelessWidget {
  final String range;
  final String label;
  final bool isCurrent;

  const _TdsRangeLegend({
    required this.range,
    required this.label,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.primary : AppColors.inputFill,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            range,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isCurrent ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _MetricDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String status;
  final Color color;
  final IconData icon;

  const _MetricDetailCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 14,
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const Gap(6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const Gap(2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
          const Gap(6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
