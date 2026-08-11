import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../home/domain/entities/blog_entity.dart';

class BlogsNewsPage extends StatefulWidget {
  final List<BlogEntity>? initialBlogs;

  const BlogsNewsPage({super.key, this.initialBlogs});

  @override
  State<BlogsNewsPage> createState() => _BlogsNewsPageState();
}

class _BlogsNewsPageState extends State<BlogsNewsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Purifier Guide',
    'Health & Wellness',
    'Leadership & Vision',
    'Commercial & Industrial',
    'TDS Guide',
  ];

  late final List<BlogEntity> _allBlogs;

  @override
  void initState() {
    super.initState();
    if (widget.initialBlogs != null && widget.initialBlogs!.isNotEmpty) {
      _allBlogs = widget.initialBlogs!;
    } else {
      _allBlogs = const [
        BlogEntity(
          id: 'blog-ro-uv-uf',
          title: 'RO, UV, or UF: How to Choose the Right Water Purifier for Your Home',
          category: 'Purifier Guide',
          date: '22 Jul 2026',
          readTime: '5 min read',
          imageUrl:
              'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-22-at-12.01.14-PM.webp',
          content:
              'Choosing the right water purifier for your home in Bangladesh can be overwhelming given the vast array of purification technologies available today. The three most common technologies are Reverse Osmosis (RO), Ultra Violet (UV) purification, and Ultra Filtration (UF). Understanding how each technology works and matching it to your source water quality is key to making an informed investment for your family\'s health.\n\n## 1. Reverse Osmosis (RO) Purification\nReverse Osmosis is the gold standard of modern water purification. RO systems pass water under high pressure through a semi-permeable membrane with tiny pores (approx 0.0001 microns).\n\n• Best For: High TDS water (> 200 PPM), borewell/groundwater, saline/brackish water, and water contaminated with heavy metals (Arsenic, Lead, Iron).\n• Key Advantages: Eliminates up to 99% of Total Dissolved Solids, heavy metals, microplastics, viruses, and bacteria.\n• Essential Note: RO purifiers remove both harmful contaminants and minerals, so Aqua Point RO models include Mineral Booster technology to restore essential calcium and magnesium.\n\n## 2. Ultra Violet (UV) Purification\nUV water purifiers use high-intensity UV radiation to destroy the DNA of harmful micro-organisms, inactivating bacteria, viruses, and cysts without adding chemicals.\n\n• Best For: Low TDS tap water (< 200 PPM) supplied by municipal authorities that is free from heavy metals.\n• Key Advantages: Retains natural minerals, uses minimal electricity, works at high flow rates, and requires no water wastage.\n• Limitation: Does not change the chemical composition or lower high TDS levels in water.\n\n## 3. Ultra Filtration (UF) Technology\nUF utilizes a hollow fiber membrane to physically filter out suspended solids, rust, silt, and large bacteria without using electricity or chemical additives.\n\n• Best For: Areas with consistent clean supply where electrical power is unstable and water TDS is naturally safe (< 150 PPM).\n• Key Advantages: Zero electricity operation, zero water wastage, durable filter life.\n\n> "A common mistake in Bangladesh is buying an RO purifier for low-TDS municipal tap water, or a UV filter for iron-rich tubewell water. Always test your TDS before deciding!"\n\n## Recommended Decision Matrix\n1. TDS > 200 PPM or Iron/Arsenic Present: Choose RO or RO+UV+UF Combination.\n2. TDS < 200 PPM & Biological Risk Only: Choose UV+UF Purifier.\n3. Frequent Power Outages & Low TDS: Choose Gravity/UF Water Purifier.\n\nAt Aqua Point, we offer free home water testing across Dhaka and Bangladesh to help you select the precise purification system tailored to your water source.',
        ),
        BlogEntity(
          id: 'blog-boiled-vs-purified',
          title: 'Boiled Water vs. Purified Water: Which is Better for Your Health?',
          category: 'Health & Wellness',
          date: '22 Jul 2026',
          readTime: '6 min read',
          imageUrl:
              'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-22-at-12.26.03-PM.webp',
          content:
              'For generations, boiling water has been the traditional method for purifying drinking water in households across Bangladesh. However, with rising industrial pollution, groundwater contamination, and heavy metal presence, many families wonder: Is boiling water still sufficient, or is modern multi-stage purification necessary?\n\n## The Science Behind Boiling Water\nBoiling water involves heating water to 100°C (212°F) for at least 1 to 3 minutes.\n\n• What Boiling Achieves: Boiling kills biological pathogens including heat-sensitive bacteria, viruses, and parasites like Giardia and E. coli.\n• Critical Limitations of Boiling:\n  1. Heavy Metals: Boiling does NOT remove heavy metals like Arsenic, Iron, Lead, or Cadmium. In fact, boiling concentrates dissolved metals as pure steam evaporates!\n  2. Chemical Pollutants: Boiling cannot eliminate pesticides, chlorine derivatives, microplastics, or industrial effluents.\n  3. Energy & Time Consumption: Boiling 10 liters daily consumes substantial gas (LPG) and time, requiring cooling before consumption.\n  4. Recontamination Risk: Storing boiled water in unsterilized containers exposes it to airborne bacteria.\n\n## How Modern Purified Water Compares\nAdvanced multi-stage RO+UV+UF water purifiers provide a comprehensive defense against both biological and chemical hazards.\n\n• Complete Contaminant Removal: Activated carbon blocks absorb unpleasant taste, odor, pesticides, and chlorine, while RO membranes eliminate heavy metals and micro-solids down to 0.0001 microns.\n• Instant On-Demand Safe Water: Purifiers provide purified, temperature-controlled water at the touch of a button without waiting for boiling and cooling.\n• Mineral Balance: Aqua Point purifiers utilize Alkaline and Mineralizer cartridges to ensure optimal pH (7.2 - 8.0) and essential mineral restoration.\n\n> "While boiling kills micro-organisms, it cannot eliminate chemical toxins or heavy metals like Arsenic and Lead. Modern multi-stage filtration is essential for comprehensive water safety."\n\n## Feature Comparison Overview\nFeature | Boiled Water | Aqua Point Purified Water\nKills Bacteria & Viruses | Yes | Yes (UV + RO)\nRemoves Heavy Metals | No | Yes (RO System)\nRemoves Chlorine & Odor | Partial | Complete (Activated Carbon)\nEnergy Cost | High Gas/LPG Cost | Low Electricity Usage\nConvenience | Low (Boil & Cool) | High (Instant Drinking)\n\n## Conclusion\nWhile boiling remains a vital backup in emergencies, daily reliance on boiling is no longer sufficient for urban and rural water sources contaminated with heavy metals and chemical runoff. Investing in a high-efficiency Aqua Point water purifier ensures total peace of mind for your family\'s health.',
        ),
        BlogEntity(
          id: 'blog-ceo-journey',
          title: 'Leadership & Vision: The Entrepreneurial Journey of Enjamamul Haque (Kiron)',
          category: 'Leadership & Vision',
          date: '25 Jul 2026',
          readTime: '7 min read',
          imageUrl:
              'https://aquapointbd.com/wp-content/uploads/2026/07/Picsart_25-11-23_21-34-18-298.jpg.webp',
          content:
              'Behind every pioneering company lies a story of perseverance, innovation, and an unwavering mission to solve a fundamental human problem. For Aqua Point, that journey began with Enjamamul Haque (Kiron), Founder and CEO, whose vision transformed household water purification standards across Bangladesh.\n\n## The Genesis: A Passion for Pure Water\nGrowing up in Bangladesh, Enjamamul Haque observed firsthand the persistent health issues caused by unsafe drinking water and unreliable purification systems. Many families struggled with high-iron groundwater, saline water in coastal areas, and sub-standard filtration units that required constant costly repairs.\n\nDriven by a desire to bring authentic, high-quality international purification technology to local households, Kiron founded Aqua Point with a clear mandate: "Pure Water for Every Home, Engineered without Compromise."\n\n## Overcoming Early Entrepreneurial Challenges\nBuilding a trusted brand in Bangladesh\'s competitive water technology market was no small task.\n\n• Establishing Direct Imports & Quality Control: Kiron forged partnerships with premier global component manufacturers in Taiwan, Vietnam, and Korea, ensuring every membrane, pump, and housing met rigorous NSF and ISO standards.\n• Customer-Centric After-Sales Service: Kiron recognized that selling a purifier was only the beginning. He pioneered Aqua Point\'s signature 24/7 technician support and scheduled maintenance alerts, establishing an unmatched standard in customer trust.\n• Commercial & Industrial Expansion: Under his leadership, Aqua Point expanded from residential purifiers into large-scale commercial plants, battery water production systems, and industrial RO solutions for textile and food processing industries.\n\n> "Business success isn\'t measured solely by growth figures; it\'s measured by the number of families who wake up every morning with access to clean, safe, and life-giving water." — Enjamamul Haque (Kiron)\n\n## Key Milestones Under Kiron\'s Leadership\n1. 2020: Launch of flagship residential RO series featuring double-O-ring leak-proof technology.\n2. 2022: Expansion into commercial battery water plants and industrial wastewater management.\n3. 2024: Establishment of Aqua Point Care digital service network covering all 64 districts in Bangladesh.\n4. 2026: Introduction of AI-assisted smart leak detection and real-time TDS monitoring app integration.\n\n## Looking Ahead: A Greener & Healthier Tomorrow\nToday, under Enjamamul Haque (Kiron)\'s leadership, Aqua Point continues to innovate with eco-friendly zero-water-waste recovery systems and solar-compatible industrial plants. Kiron\'s journey serves as an inspiring blueprint for young Bangladeshi entrepreneurs aspiring to build impactful businesses that serve society.',
        ),
        BlogEntity(
          id: 'blog-commercial-battery-water',
          title: 'What is Required to Set Up a Commercial Battery Water Plant? (Complete Checklist)',
          category: 'Commercial & Industrial',
          date: '23 Jul 2026',
          readTime: '8 min read',
          imageUrl:
              'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-23-at-10.18.31-AM.webp',
          content:
              'Setting up a commercial battery water (demineralized / deionized water) plant is a highly lucrative business opportunity in Bangladesh, driven by high demand from lead-acid battery manufacturers, solar power storage, industrial machinery, automotive workshops, and chemical laboratories. Battery water requires exceptionally low electrical conductivity (< 5 µS/cm) and zero dissolved minerals. Here is the complete setup checklist from Aqua Point\'s industrial engineering team.\n\n## 1. Raw Water Analysis & Pre-Treatment System\nBefore designing the plant, a laboratory water test is mandatory to determine raw water TDS, Iron, Silica, and Hardness.\n\n• Raw Water Pump & Feed Tank: Heavy-duty stainless steel or food-grade FRP feed tank (1,000L - 5,000L).\n• Sand & Multi-Media Filter: Removes suspended solids, turbidity, and physical particles down to 20 microns.\n• Activated Carbon Filter: Eliminates chlorine, organic compounds, color, and odor that could degrade RO membranes.\n• Water Softener Plant: Uses ion-exchange resin to remove calcium and magnesium ions, preventing scaling.\n\n## 2. Double-Pass Reverse Osmosis (RO) Assembly\nStandard single-pass RO is often insufficient for battery-grade purity. A double-pass RO system reduces TDS from ~500 PPM down to < 10 PPM.\n\n• High-Pressure Stainless Steel Pumps (CNP / Grundfos): Delivers required pressure (15-20 bar).\n• Industrial RO Membranes (Dow Filmtec / Hydranautics): High rejection rate (> 99.5%) for dissolved salts.\n• Stainless Steel Membrane Pressure Vessels (SS304/SS316 or FRP): Engineered for continuous heavy duty operations.\n\n## 3. Mixed-Bed Deionization (DI) / EDI System\nTo achieve strict battery water standards (TDS ~0 PPM, Conductivity < 2-5 µS/cm), water must pass through a Deionization Polishing Unit.\n\n• Mixed-Bed Resin Column: Contains intimate mixture of Strong Acid Cation and Strong Base Anion resins.\n• Conductivity / TDS Meter (Online Digital Monitor): Provides real-time purity monitoring with automatic dump valve if threshold is exceeded.\n\n## 4. Storage, Automatic Bottling & Packaging Line\n• Pure DM Water Storage Tanks: High-density polyethylene (HDPE) or SS316L tanks with air breathing filters.\n• Automatic Rinsing, Filling & Capping Machine: Handles 5L, 10L, and 20L jars with zero manual contamination.\n• Shrink Sleeve Labeling & Batch Coding Printer: For professional branding, BSTI alignment, and expiry tracking.\n\n> "Quality is everything in battery water. Even 10 PPM of iron or chloride can ruin a Lead-Acid battery plate. Aqua Point guarantees plant output under 2 µS/cm."\n\n## Plant Capacity & Footprint Recommendations\nPlant Capacity | Minimum Footprint | Target Market\n500 LPH | 250 sq. ft | Local Workshops & Auto Garages\n1,000 LPH | 450 sq. ft | Regional Distributors & Solar Dealers\n3,000 LPH+ | 900 sq. ft | Industrial Battery Manufacturers\n\nAqua Point provides turnkey commercial battery water plant setup services across Bangladesh, including technical drawings, installation, BSTI documentation support, and operator training.',
        ),
        BlogEntity(
          id: 'blog-tds-guide',
          title: 'Understanding Water TDS Levels & WHO Drinking Water Standards',
          category: 'TDS Guide',
          date: '15 Jul 2026',
          readTime: '4 min read',
          imageUrl:
              'https://aquapointbd.com/wp-content/uploads/2026/07/retouch_2025022715142401.jpg.webp',
          content:
              'When evaluating drinking water quality, TDS (Total Dissolved Solids) is the most frequently cited metric. But what exactly is TDS, how does it affect human health, and what are the World Health Organization (WHO) and Bangladesh Drinking Water Quality Standards?\n\n## What is TDS?\nTotal Dissolved Solids (TDS) refers to the combined concentration of all inorganic salts and organic matter dissolved in water. The primary mineral constituents usually include:\n\n• Cations: Calcium (Ca²⁺), Magnesium (Mg²⁺), Sodium (Na⁺), and Potassium (K⁺).\n• Anions: Carbonates (CO₃²⁻), Bicarbonates (HCO₃⁻), Chlorides (Cl⁻), Sulfates (SO₄²⁻), and Nitrates (NO₃⁻).\n• Contaminants: Dissolved heavy metals like Iron (Fe), Arsenic (As), Lead (Pb), and Fluoride.\n\nTDS is typically measured in Parts Per Million (PPM) or Milligrams Per Liter (mg/L).\n\n## WHO & Bangladesh Standard TDS Chart\nTDS Level (PPM) | Rating | Health & Palatability Impact\nLess than 50 | Low Mineral | Flat/tasteless water; lacks minerals.\n50 to 150 | Excellent | Ideal range for drinking water; crisp & safe.\n150 to 300 | Good | Great drinking water quality.\n300 to 600 | Fair | Acceptable; noticeable mineral taste.\n600 to 900 | Poor | High mineral deposits; pipe scaling.\nAbove 1200 | Unacceptable | Unsafe for daily drinking; potential toxic metals.\n\n## Why High TDS Water is Dangerous in Bangladesh\nIn many districts of Bangladesh (such as Khulna, Jessore, Gazipur, and Narayanganj), tube-well water frequently records TDS levels between 600 and 1,800 PPM due to salinity intrusion, industrial runoff, and high iron content.\n\n• Health Risks: Prolonged consumption of high-TDS water containing heavy metals increases the risk of kidney stones, hypertension, gastrointestinal disorders, and heavy metal toxicity.\n• Appliance Damage: High TDS water causes heavy limescale deposits inside electric kettles, water heaters, and pipe fittings.\n\n> "A common myth is that 0 TDS water is healthiest. In reality, ideal drinking water should have balanced TDS between 80 and 150 PPM, enriched with essential calcium and magnesium."\n\n## How Aqua Point Solves TDS Imbalance\nAqua Point Reverse Osmosis systems utilize an adjustable Mineral TDS Controller. The RO membrane first strips out heavy metals and excess salts down to ~20 PPM, and the Mineralizer stage enriches the purified water back to a healthy, delicious 80–120 PPM range.\n\nTest your home water TDS for free today by requesting an Aqua Point technician visit!',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showContactOptionsModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        final secTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
        final cardBg = isDark ? AppColors.darkBackground : AppColors.background;
        final borderCol = isDark ? AppColors.darkBorder : AppColors.border;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(16),
              Text(
                'Contact Aqua Point Experts',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Gap(6),
              Text(
                'Get free advice on water purifiers, TDS testing, & commercial plants',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: secTextColor,
                ),
              ),
              const Gap(20),
              ListTile(
                tileColor: cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: borderCol),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  'Call Helpline: 01780-885841',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: textColor),
                ),
                subtitle: Text('Available 9 AM - 9 PM daily', style: GoogleFonts.inter(fontSize: 12, color: secTextColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling Aqua Point Hotline: 01780-885841 📞', style: GoogleFonts.inter()),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Gap(12),
              ListTile(
                tileColor: cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: borderCol),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.success, size: 22),
                ),
                title: Text(
                  'WhatsApp Support: +8801780885841',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: textColor),
                ),
                subtitle: Text('Instant chat with water specialist', style: GoogleFonts.inter(fontSize: 12, color: secTextColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening WhatsApp Support (+8801780885841) 💬', style: GoogleFonts.inter()),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Gap(16),
            ],
          ),
        );
      },
    );
  }

  void _openBlogDetail(BlogEntity blog) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderCol = isDark ? AppColors.darkBorder : AppColors.border;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: borderCol,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const Gap(24),

                  // Header Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          blog.category ?? 'Purifier Guide',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const Gap(6),
                      Text(
                        blog.readTime ?? '5 min read',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textSecColor,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),

                  // Title
                  Text(
                    blog.title,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                  const Gap(12),

                  // Published Date & Author
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const Gap(6),
                      Text(
                        'Aqua Point Water Care Team',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        '•  ${blog.date}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: textSecColor,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),

                  // Featured Image with Network & Error Fallback Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      blog.imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 220,
                        width: double.infinity,
                        color: isDark ? AppColors.darkBackground : AppColors.background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.article_rounded,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const Gap(8),
                            Text(
                              'Aqua Point Official Article',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: textSecColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(24),

                  // Rich Content Renderer
                  _buildFormattedBlogContent(blog.content ?? '', isDark),

                  const Gap(32),
                  const Divider(height: 1),
                  const Gap(24),

                  // Bottom Expert CTA Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Have Questions About Your Water Quality?',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'Our certified water specialists provide free consultation and home TDS testing.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: textSecColor,
                          ),
                        ),
                        const Gap(16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showContactOptionsModal(context, isDark);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.headset_mic_rounded, size: 20),
                            label: Text(
                              'Need Expert Water Advice? Contact Aqua Point',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Share Article Action
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Article link shared successfully! 📲',
                              style: GoogleFonts.inter(),
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderCol),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.share_rounded,
                        color: textColor,
                        size: 18,
                      ),
                      label: Text(
                        'Share Article',
                        style: GoogleFonts.inter(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const Gap(24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormattedBlogContent(String content, bool isDark) {
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderCol = isDark ? AppColors.darkBorder : AppColors.border;

    if (content.isEmpty) {
      return Text(
        'Water purification is vital for clean, disease-free living. Aqua Point systems utilize multi-stage filtration ensuring every drop of water you drink meets international health standards.',
        style: GoogleFonts.inter(
          fontSize: 15,
          color: textColor,
          height: 1.6,
        ),
      );
    }

    final blocks = content.split('\n\n');
    final List<Widget> widgets = [];

    for (final block in blocks) {
      final trimmed = block.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('## ')) {
        // Section Header H2
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              trimmed.substring(3).trim(),
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('### ')) {
        // Section Header H3
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              trimmed.substring(4).trim(),
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('> ')) {
        // Quote Callout
        final quoteText = trimmed.replaceAll('> ', '').replaceAll('"', '').trim();
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    '"$quoteText"',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (trimmed.contains('|') && trimmed.contains('\n')) {
        // Simple Table Block
        final lines = trimmed.split('\n').where((l) => l.contains('|')).toList();
        if (lines.length >= 2) {
          final rows = lines.map((l) => l.split('|').map((c) => c.trim()).toList()).toList();
          // Filter out markdown table header separators like ---
          final cleanRows = rows.where((r) => !r.any((c) => c.contains('---'))).toList();

          if (cleanRows.isNotEmpty) {
            widgets.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.2),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(1.8),
                    },
                    children: cleanRows.asMap().entries.map((entry) {
                      final rowIndex = entry.key;
                      final row = entry.value;
                      final isHeader = rowIndex == 0;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: isHeader
                              ? (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant)
                              : Colors.transparent,
                        ),
                        children: row.map((cell) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              cell,
                              style: GoogleFonts.inter(
                                fontSize: isHeader ? 12.5 : 12,
                                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                                color: isHeader ? textColor : secTextColor,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }
        }
      } else if (trimmed.contains('\n• ') || trimmed.startsWith('• ') || trimmed.contains('\n1. ') || trimmed.startsWith('1. ')) {
        // Bullet or Numbered List Items
        final lines = trimmed.split('\n');
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                final lineTrim = line.trim();
                if (lineTrim.isEmpty) return const SizedBox.shrink();
                final isBullet = lineTrim.startsWith('• ');
                final isNum = RegExp(r'^\d+\.\s').hasMatch(lineTrim);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isBullet)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 10),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      else if (isNum)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            lineTrim.split(' ').first,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          isBullet
                              ? lineTrim.substring(2).trim()
                              : (isNum ? lineTrim.substring(lineTrim.indexOf(' ') + 1).trim() : lineTrim),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.5,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      } else {
        // Standard Paragraph
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              trimmed,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                height: 1.6,
                color: textColor,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.darkBackground : AppColors.background;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textTertiaryColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final filteredBlogs = _allBlogs.where((blog) {
      final matchesQuery = blog.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (blog.content?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesCategory =
          _selectedCategory == 'All' || (blog.category == _selectedCategory);
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Water Health Blogs & News',
          style: GoogleFonts.outfit(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Field Bar
          Container(
            color: surfaceColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Search blogs, guides & water tips...',
                hintStyle: GoogleFonts.inter(
                  color: textTertiaryColor,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: textSecColor,
                  size: 22,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: textSecColor,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: backgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Horizontal Category Selector Chips
          Container(
            color: surfaceColor,
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = cat);
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: backgroundColor,
                      labelStyle: GoogleFonts.inter(
                        color: isSelected
                            ? Colors.white
                            : textSecColor,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : borderColor,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Blogs List View
          Expanded(
            child: filteredBlogs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 48,
                          color: textTertiaryColor,
                        ),
                        const Gap(12),
                        Text(
                          'No articles found matching your criteria.',
                          style: GoogleFonts.inter(
                            color: textSecColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = filteredBlogs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isDark ? [] : AppShadows.soft,
                          border: Border.all(color: borderColor),
                        ),
                        child: InkWell(
                          onTap: () => _openBlogDetail(blog),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Blog Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: backgroundColor,
                                    child: Image.network(
                                      blog.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                child: Icon(
                                                  Icons.image_outlined,
                                                  color: textTertiaryColor,
                                                  size: 32,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                                const Gap(16),

                                // Blog Text Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? AppColors.primary.withValues(alpha: 0.2)
                                                  : AppColors.primaryLight,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              blog.category ?? 'Purifier Guide',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            blog.date,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: textSecColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(8),
                                      Text(
                                        blog.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                          height: 1.3,
                                        ),
                                      ),
                                      const Gap(12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.menu_book_rounded,
                                            size: 14,
                                            color: textSecColor,
                                          ),
                                          const Gap(4),
                                          Text(
                                            blog.readTime ?? '5 min read',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: textSecColor,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'Read More',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

