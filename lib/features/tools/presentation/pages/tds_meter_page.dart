import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../home/domain/entities/water_quality_entity.dart';

typedef WaterQualityDetailPage = TdsMeterPage;

class TdsMeterPage extends StatefulWidget {
  final WaterQualityEntity? waterQuality;

  const TdsMeterPage({super.key, this.waterQuality});

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
      SnackBar(
        content: Text(
          'Live Water Analysis complete! Result: 99% Pure 💧',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Live TDS & Water Quality Gauge',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Water Purity Health Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.medium,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WATER PURITY HEALTH SCORE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Gap(8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$_healthScore',
                              style: GoogleFonts.outfit(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '/100',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Gap(6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Grade A+ • Safe Drinking Water',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const Gap(4),
                        Text(
                          _status,
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),

            // Live TDS Gauge Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.soft,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live TDS Gauge',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Icon(
                        Icons.sensors_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    'Total Dissolved Solids in PPM',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(32),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: (_tds / 300).clamp(0.0, 1.0),
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
                          if (_isScanning)
                            const CircularProgressIndicator(
                              color: AppColors.primary,
                            )
                          else ...[
                            Text(
                              '$_tds',
                              style: GoogleFonts.outfit(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'PPM',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Gap(32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TdsRangeLegend(
                        range: '0 - 50',
                        label: 'Pure (RO)',
                        isCurrent: _tds <= 50,
                      ),
                      _TdsRangeLegend(
                        range: '51 - 150',
                        label: 'Ideal',
                        isCurrent: _tds > 50 && _tds <= 150,
                      ),
                      _TdsRangeLegend(
                        range: '151 - 300',
                        label: 'Fair',
                        isCurrent: _tds > 150 && _tds <= 300,
                      ),
                    ],
                  ),
                  const Gap(24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isScanning ? null : _simulateReTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.sync_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        _isScanning
                            ? 'Testing Water Quality...'
                            : 'Re-Test Water Quality',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Detailed Water Parameters Breakdown Grid
            Text(
              'Chemical & Mineral Breakdown',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(16),

            Row(
              children: [
                Expanded(
                  child: _MetricDetailCard(
                    title: 'Iron (Fe)',
                    value: '$_iron mg/L',
                    subtitle: 'Safe Limit: < 0.3',
                    status: 'Excellent',
                    color: AppColors.primary,
                    icon: Icons.invert_colors_rounded,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _MetricDetailCard(
                    title: 'pH Level',
                    value: '$_ph pH',
                    subtitle: 'Ideal: 6.5 - 8.5',
                    status: 'Optimal',
                    color: AppColors.success,
                    icon: Icons.science_rounded,
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _MetricDetailCard(
                    title: 'Hardness',
                    value: _hardness,
                    subtitle: '25 mg/L CaCO3',
                    status: 'Soft Water',
                    color: AppColors.warning,
                    icon: Icons.bubble_chart_rounded,
                  ),
                ),
                const Gap(12),
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
            const Gap(24),

            // RO Membrane & Filter Health Card
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
                      Text(
                        'RO Filter Health Status',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '92% Good',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.92,
                      minHeight: 10,
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.success,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'Next scheduled filter maintenance in approximately 114 days.',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: isCurrent ? null : Border.all(color: AppColors.border),
          ),
          child: Text(
            range,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isCurrent ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
        const Gap(6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
          ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Gap(4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 11,
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
