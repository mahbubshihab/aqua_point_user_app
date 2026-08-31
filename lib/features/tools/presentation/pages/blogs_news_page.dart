import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/blog_entity.dart';

class BlogsNewsPage extends StatefulWidget {
  final int initialIndex;
  final List<BlogEntity>? initialBlogs;

  const BlogsNewsPage({
    super.key,
    this.initialIndex = 0,
    this.initialBlogs,
  });

  @override
  State<BlogsNewsPage> createState() => _BlogsNewsPageState();
}

class _BlogsNewsPageState extends State<BlogsNewsPage> {
  late final List<BlogEntity> _blogs;
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    if (widget.initialBlogs != null && widget.initialBlogs!.isNotEmpty) {
      _blogs = widget.initialBlogs!;
    } else {
      _blogs = const [
        BlogEntity(
          id: 'blog-ro-uv-uf',
          title: 'RO, UV, or UF: How to Choose the Right Water Purifier for Your Home',
          category: 'Purifier Guide',
          date: 'July 23, 2026',
          author: 'Enjamamul Haque (Kiron)',
          readTime: '6 min read',
          imageUrl: 'assets/images/blog_ro_header.png',
          content:
              'Ensuring every drop your family drinks is safe and pure.\n\nChoosing the right water purifier for your home in Bangladesh can be overwhelming given the vast array of purification technologies available today. The three most common technologies are Reverse Osmosis (RO), Ultraviolet (UV) purification, and Ultrafiltration (UF). Understanding how each technology works and matching it to your source water quality is key to making an informed investment for your family\'s health.\n\n## 1. Reverse Osmosis (RO): The Heavy-Duty Purifier\n\n> "Best For: High TDS (Total Dissolved Solids) water, hard water, underground water, or water with a salty taste."\n\n![RO Membrane Pore Diagram](assets/images/blog_ro_diagram.png)\n\nReverse Osmosis is the gold standard of modern water purification. RO systems use a high-pressure pump to force water under pressure through a semi-permeable membrane with microscopic pores (approx 0.0001 microns).\n\n• Heavy-Duty Filtration: Eliminates up to 99% of Total Dissolved Solids (TDS), heavy metals (Arsenic, Lead, Iron), fluoride, microplastics, bacteria, and viruses.\n• Water Taste & Quality: Ideal for borewell/groundwater, saline/brackish water, or water with noticeable mineral deposits and hardness.\n• Essential Note: RO purifiers remove both harmful contaminants and minerals, so Aqua Point RO models feature Mineral Booster technology to restore essential calcium and magnesium.\n\n## 2. Ultraviolet (UV) Purification: The Germ Killer\n\n> "Best For: Municipal/Supply water that is visually clean and has a sweet taste (Low TDS) but may contain unseen bacteria or viruses."\n\n![UV Sterilization System](assets/images/blog_uv_diagram.png)\n\nUV water purifiers use high-intensity ultraviolet radiation to destroy the DNA of harmful micro-organisms, inactivating bacteria, viruses, and cysts without adding chemicals.\n\n• Pathogen Destruction: High-intensity UV lamps sterilize 99.99% of biological pathogens including E. coli, Cholera, and Typhoid.\n• Mineral Retention: Retains natural beneficial minerals in water without altering chemical composition or taste.\n• Operation: Uses minimal electricity, operates at high flow rates, and produces zero wastewater.\n• Limitation: Does not lower high TDS levels or remove dissolved chemical pollutants and heavy metals.\n\n## 3. Ultrafiltration (UF): The Electricity-Free Guard\n\n> "Best For: Areas with frequent power cuts and water that contains visible dirt or mud (Low TDS)."\n\n![UF System Filtration](assets/images/blog_uf_diagram.jpg)\n\nUltrafiltration utilizes hollow fiber membranes with pore sizes around 0.01 microns to physically filter out suspended solids, rust, silt, and large bacteria without using electricity or chemical additives.\n\n• Zero Electricity & Waste: Works on normal tap water pressure with zero water wastage and zero electricity consumption.\n• Durable Physical Barrier: Effective at blocking mud, rust, suspended particles, and cysts.\n• Limitation: Cannot remove dissolved chemicals, heavy metals, or dissolved salts (high TDS).\n\n## Quick Comparison Guide\n\nFeature | Reverse Osmosis (RO) | Ultraviolet (UV) | Ultrafiltration (UF)\nMechanism | 0.0001 µm Membrane | UV Light Sterilization | 0.01 µm Hollow Fiber\nRemoves Heavy Metals & TDS | Yes (Up to 99%) | No | No\nKills Bacteria & Viruses | Yes | Yes (99.99%) | Physical Trap Only\nElectricity Required | Yes (High Pressure Pump) | Yes (UV Lamp) | No (Zero Electricity)\nWater Wastage | Yes (Flushing Drain) | No (Zero Waste) | No (Zero Waste)\nIdeal Water Source | High TDS (> 200 PPM) | Low TDS (< 200 PPM) | Low TDS (< 150 PPM)\n\n## The Final Verdict & Next Steps\n\n1. High TDS (> 200 PPM) or Iron/Arsenic Present: Choose RO or RO+UV+UF Combination.\n2. Low TDS (< 200 PPM) & Visually Clean Water: Choose UV+UF Purifier.\n3. Frequent Power Outages & Low TDS with Mud/Rust: Choose Gravity/UF Water Purifier.\n\n## Ready to Secure Pure Drinking Water?\n\nAt Aqua Point BD, founder Enjamamul Haque (Kiron) and our certified water engineering team offer free home water TDS testing and consultation across Bangladesh. Contact our specialists today to select the perfect purification system for your family\'s health!',
        ),
        BlogEntity(
          id: 'blog-boiled-vs-purified',
          title: 'Boiled Water vs. Purified Water: Which is Better for Your Health?',
          category: 'Health & Wellness',
          date: 'July 22, 2026',
          author: 'Aqua Point BD',
          readTime: '6 min read',
          imageUrl: 'assets/images/blog_boiled_purifier.png',
          content:
              'For generations, boiling water has been the traditional method for purifying drinking water in households across Bangladesh. However, with rising industrial pollution, groundwater contamination, and heavy metal presence, many families wonder: Is boiling water still sufficient, or is modern multi-stage purification necessary?\n\n## The Traditional Approach: Boiled Water\n\n> "Boiling water effectively kills heat-sensitive micro-organisms like bacteria, viruses, and parasites. However, it fails to remove chemical contaminants, heavy metals, and dissolved solids."\n\n![Water boiling in glass pot over flame](assets/images/blog_boiled_water.png)\n\nBoiling water involves heating water to 100°C (212°F) for at least 1 to 3 minutes.\n\n✅ Kills biological pathogens including heat-sensitive bacteria, viruses, and parasites (Giardia, E. coli, Cholera).\n✅ Accessible method that requires no specialized hardware or machinery.\n❌ Does Not Remove Chemicals: Boiling cannot eliminate pesticides, chlorine derivatives, microplastics, or industrial effluents.\n❌ Heavy Metals Contamination: Boiling does NOT remove heavy metals like Arsenic, Iron, Lead, or Cadmium. In fact, boiling concentrates dissolved metals as pure water evaporates as steam!\n❌ Energy & High Cost: Boiling 10 liters daily consumes substantial gas (LPG) and time, requiring waiting time for cooling.\n❌ Recontamination Risk: Storing boiled water in unsterilized containers exposes it to airborne bacteria and dust.\n\n## The Modern Solution: Purified Water\n\n> "Modern multi-stage RO+UV+UF water purifiers provide a comprehensive defense against both biological pathogens and toxic chemical hazards."\n\n![Man taking water from wall purifier dispenser](assets/images/blog_boiled_purifier.png)\n\nAdvanced multi-stage filtration systems provide total drinking safety at the tap on demand.\n\n✅ Comprehensive Filtration: Multi-stage systems (RO, UV, UF, Activated Carbon) eliminate bacteria, viruses, heavy metals, dissolved salts, pesticides, and microplastics.\n✅ Restores Essential Minerals: Aqua Point purifiers utilize Alkaline and Mineralizer cartridges to restore essential calcium and magnesium while maintaining healthy pH (7.2 - 8.0).\n✅ Instant Convenience: Delivers purified, fresh drinking water instantly without boiling, gas consumption, or waiting for water to cool down.\n✅ Eliminates Odor & Taste: Carbon block filters absorb chlorine taste, foul smell, and organic impurities.\n❌ Maintenance Cost: Requires periodic cartridge and membrane replacement to maintain maximum purification efficiency.\n\n## Quick Comparison Table\n\nFeature | Boiled Water | Purified Water (RO+UV+UF)\nKills Bacteria & Viruses | ✅ Yes (100°C Heat) | ✅ Yes (UV Sterilization + RO)\nRemoves Heavy Metals (Arsenic, Lead) | ❌ No (Concentrates Metals) | ✅ Yes (Up to 99% RO Removal)\nRemoves Chemical Pollutants | ❌ No | ✅ Yes (Activated Carbon)\nRemoves Microplastics & Rust | ❌ No | ✅ Yes (UF & Sediment Filters)\nRetains/Restores Healthy Minerals | ❌ Neutral (Can alter taste) | ✅ Yes (Mineralizer Cartridge)\nConvenience & Speed | ❌ Low (Requires Boiling & Cooling) | ✅ High (Instant Pure Water)\nOperating Cost | ❌ High LPG Gas Consumption | ✅ Low Electricity Usage\n\n## The Final Verdict\n\nWhile boiling water remains a vital emergency measure when no filtration equipment is available, daily reliance on boiling is no longer sufficient for drinking water sources contaminated with heavy metals, arsenic, and chemical runoff in Bangladesh. Investing in a high-efficiency Aqua Point water purifier ensures complete 360-degree protection, superior mineral balance, and instant convenience for your family\'s health.',
        ),
        BlogEntity(
          id: 'blog-ceo-journey',
          title: 'Enjamamul Haque (Kiron) – Founder & CEO, Aqua Point BD',
          category: 'Leadership & Vision',
          date: 'July 25, 2026',
          author: 'Enjamamul Haque (Kiron)',
          readTime: '7 min read',
          imageUrl: 'assets/images/blog_ceo_header.png',
          content:
              'Leadership & Vision: The Entrepreneurial Journey of Enjamamul Haque (Kiron) - The Mastermind Behind Aqua Point BD\n\n## The Mastermind Behind Aqua Point BD\nBehind every pioneering company lies a story of perseverance, innovation, and an unwavering mission to solve a fundamental human problem. For Aqua Point BD, that journey began with Enjamamul Haque (Kiron), Founder and CEO, whose visionary leadership transformed household and commercial water purification standards across Bangladesh.\n\nDriven by a deep commitment to public health, Kiron identified a critical gap in the market: while safe drinking water is a fundamental right, thousands of households struggled with high TDS (Total Dissolved Solids), iron contamination, and unreliable filtration hardware. Under his guidance, Aqua Point BD evolved from a local endeavor into a nationwide trusted brand synonymous with purity, engineering precision, and authentic customer care.\n\n![Enjamamul Haque (Kiron) working at desk](assets/images/blog_ceo_desk.png)\n\n## The Beginning & Business Philosophy\nThe story of Aqua Point BD started with a simple yet powerful realization: access to clean water shouldn\'t be a luxury or a gamble. Early in his career, Kiron recognized that many water purifiers in Bangladesh were assembled using low-grade components that failed quickly or failed to eliminate toxic heavy metals like Arsenic and Lead.\n\nKiron established Aqua Point BD on an unyielding business philosophy—putting customer health and product authenticity above short-term profit margins. He instituted rigorous quality standards, ensuring every membrane, filter cartridge, and fittings met international NSF and ISO specifications.\n\n> "Business success isn\'t just about selling products; it depends heavily on the positive impact you can create in your customers\' lives." – Enjamamul Haque (Kiron)\n\n![Enjamamul Haque (Kiron) in thought at desk](assets/images/blog_ceo_thought.png)\n\n## Teamwork & Technological Advancement\nNo great achievement is accomplished alone. Kiron built a culture of excellence by assembling a dedicated team of certified water treatment engineers, skilled technicians, and customer support specialists. He fostered an environment where continuous learning and technological innovation thrive.\n\nUnder Kiron\'s leadership, Aqua Point BD introduced multi-stage RO+UV+UF purification systems with smart mineral controllers, zero-leak double O-ring technology, and custom industrial demineralized (DM) battery water plants. His focus on continuous research ensured that Aqua Point BD stayed ahead of evolving environmental challenges across both urban and coastal regions of Bangladesh.\n\n![Enjamamul Haque (Kiron) speaking at event podium](assets/images/blog_ceo_podium.jpg)\n\n## Social Responsibility & A Broader Perspective\nFor Kiron, business leadership extends far beyond financial metrics. He believes deeply in corporate social responsibility and community empowerment. Aqua Point BD regularly conducts free community water TDS testing drives, educational awareness programs on waterborne diseases, and clean water donation initiatives for schools and rural clinics.\n\nKiron\'s broader perspective emphasizes sustainable water management, encouraging households and industrial clients alike to adopt eco-friendly filtration methods and water recovery systems that reduce environmental waste.\n\n![Enjamamul Haque (Kiron) talking on phone at desk](assets/images/blog_ceo_phone.png)\n\n## Blueprint for the Future\nAs Aqua Point BD continues its rapid growth, Kiron remains focused on the future. His strategic roadmap includes expanding digital customer care networks across all 64 districts of Bangladesh, integrating smart IoT leak-detection technology into residential units, and pioneering solar-powered water treatment facilities for off-grid coastal communities.\n\nKiron\'s entrepreneurial journey serves as an inspiring blueprint for young Bangladeshi leaders: demonstrating that with vision, integrity, and relentless dedication, local enterprise can solve vital national challenges.\n\n## Connect with Enjamamul Haque (Kiron)\n• Facebook: https://www.facebook.com/Kiron016\n• Instagram: https://www.instagram.com/kir_on09?igsh=MWZpcW1xZ2I1dmM5bw==\n• LinkedIn: https://www.linkedin.com/in/enjamamul-haque-kiron-0878b63a6?utm_source=share_via&utm_content=profile&utm_medium=member_android\n• Website: https://aquapointbd.com/',
        ),
        BlogEntity(
          id: 'blog-commercial-battery-water',
          title:
              'What is Required to Set Up a Commercial Battery Water Plant? (Complete Checklist)',
          category: 'Commercial & Industrial',
          date: 'July 23, 2026',
          author: 'Aqua Point BD',
          readTime: '8 min read',
          imageUrl: 'assets/images/blog_plant_system.jpg',
          content:
              'Setting up a commercial battery water (demineralized / deionized water) plant is a highly lucrative business opportunity in Bangladesh, driven by high demand from lead-acid battery manufacturers, solar power storage, industrial machinery, automotive workshops, and chemical laboratories. Battery water requires exceptionally low electrical conductivity (< 5 µS/cm) and zero dissolved minerals. Here is the complete setup checklist from Aqua Point\'s industrial engineering team.\n\n## 1. Required Machinery (RO + DM Plant)\n\nTo achieve strict battery water standards (TDS ~0 PPM, Conductivity < 2-5 µS/cm), the production line requires high-performance industrial filtration machinery:\n\n• Raw Water Feed Pump & Multi-Media Sand Filter: Heavy-duty pump paired with multi-grade sand filter to remove suspended solids, sediment, and turbidity down to 20 microns.\n• Activated Carbon Filter Column: Absorbs chlorine, organic contaminants, odor, and color to protect downstream membranes and resins.\n• Industrial Water Softener Plant: High-capacity ion-exchange resin tank that removes calcium and magnesium ions to eliminate hardness scaling.\n• High-Pressure Stainless Steel Pump (CNP/Grundfos): Delivers continuous high pressure (15-20 bar) required for double-pass reverse osmosis.\n• Double-Pass Reverse Osmosis (RO) Assembly: Dual-stage industrial RO membranes (Dow Filmtec / Hydranautics) housed in SS304/SS316 pressure vessels, reducing raw water TDS from ~500 PPM down to < 10 PPM.\n• Mixed-Bed Deionization (DI) Polishing Column: Contains strong acid cation and strong base anion resins to strip remaining trace ions, achieving zero-TDS DM battery water (< 2 µS/cm conductivity).\n• UV Sterilizer & 0.2 Micron Micro-Filter: Instantaneous bio-sterilization and final micro-polishing stage before product water storage.\n• Online Digital TDS & Conductivity Monitor: Real-time purity tracking with automatic diverter valve to flush non-compliant water.\n\n![Industrial RO & DM Demineralization System Water Plant](assets/images/blog_plant_system.jpg)\n\n## 2. Raw Water and Product Water Tanks\n\nProper storage solutions are essential to maintain pure demineralized water free from environmental recontamination and algal growth:\n\n• Raw Water Feed Storage Tank: Food-grade heavy-duty FRP or HDPE storage tank (2,000L – 5,000L capacity) to ensure consistent feed pressure and continuous plant operation.\n• Demineralized (DM) Water Product Tank: SS316L stainless steel or specialized virgin HDPE tank with internal mirror polish to prevent ion leaching.\n• Air Breather & HEPA Vent Filters: Sealed tank ventilation with 0.2 micron hydrophobic air filters to prevent airborne dust and bacterial contamination during draw-down.\n\n## 3. Filling & Packaging System\n\nAn efficient filling and packaging line ensures hygienic production, zero manual contamination, and market-ready commercial branding:\n\n• Semi-Automatic / Automatic Jar & Bottle Washer: High-pressure internal jet rinsing with DM water to clean bottles before filling.\n• Multi-Head Automatic Liquid Filling & Capping Machine: Handles 1L, 5L, 10L, and 20L commercial carboys with precision volumetric filling nozzles.\n• Induction Heat Sealing & Cap Sealing Machine: Hermetically seals bottle caps with foil liners to prevent leakage and tampering during transport.\n• Shrink Sleeve Labeling & Thermal Batch Coder: Automatic heat-shrink sleeve labeling with online inkjet printing for manufacturing date, batch number, and BSTI license details.\n\n![Automated Bottling & Packaging Line](assets/images/blog_plant_bottling.jpg)\n\n## 4. Space Requirements\n\nA well-planned factory layout ensures smooth workflow, raw material storage, production line operations, and finished goods logistics:\n\n• Small Scale Plant (500 LPH Capacity): Requires 400 - 600 sq. ft. clear floor space for local workshop and auto garage supply.\n• Medium Scale Commercial Plant (1,000 - 2,000 LPH Capacity): Requires 800 - 1,200 sq. ft. space, ideal for regional distribution, solar dealers, and IPS manufacturers.\n• Large Industrial Facility (3,000+ LPH Capacity): Requires 1,500 - 2,500 sq. ft. dedicated industrial shed with separate raw material and finished goods warehousing.\n• Layout Essentials: Waterproof epoxy flooring, 3-phase industrial power line (10-25 kW), adequate drainage, and proper ventilation.\n\n## 5. Initial Investment Overview\n\n> "The total initial investment for setting up a commercial battery water production plant in Bangladesh ranges between 3,00,000 BDT to 8,00,000 BDT depending on capacity, automation level, and machinery specifications."\n\n• Small Scale Setup (500 LPH): Estimated investment of 3,00,000 - 4,50,000 BDT covering 500 LPH RO+DI plant, manual filling, and basic storage tanks.\n• Commercial Standard Setup (1,000 LPH): Estimated investment of 5,00,000 - 8,00,000 BDT including double-pass RO, mixed-bed DI unit, semi-automatic filling line, and testing equipment.\n• Operating Expenses (OPEX): Includes resin regeneration, RO membrane replacement, electricity, packaging bottles/labels, and labor costs (~0.30 - 0.50 BDT per liter).\n\n## Conclusion\n\nEstablishing a commercial battery water plant offers strong profit margins and steady year-round demand in Bangladesh\'s expanding automotive, solar, and industrial sectors. Partnering with experienced water engineers ensures correct equipment selection, BSTI compliance, and long-term operating efficiency.\n\nAqua Point provides end-to-end turnkey commercial battery water plant setup across Bangladesh—including water testing, plant design, installation, BSTI documentation guidance, and lifetime technical support. Contact our industrial engineering team at 01780-885841 to request a customized plant proposal!',
        ),
        BlogEntity(
          id: 'blog-tds-guide',
          title: 'Understanding Water TDS Levels & WHO Drinking Water Standards',
          category: 'TDS Guide',
          date: '15 Jul 2026',
          author: 'Aqua Point BD',
          readTime: '4 min read',
          imageUrl:
              'https://aquapointbd.com/wp-content/uploads/2026/07/retouch_2025022715142401.jpg.webp',
          content:
              'When evaluating drinking water quality, TDS (Total Dissolved Solids) is the most frequently cited metric. But what exactly is TDS, how does it affect human health, and what are the World Health Organization (WHO) and Bangladesh Drinking Water Quality Standards?\n\n## What is TDS?\nTotal Dissolved Solids (TDS) refers to the combined concentration of all inorganic salts and organic matter dissolved in water. The primary mineral constituents usually include:\n\n• Cations: Calcium (Ca²⁺), Magnesium (Mg²⁺), Sodium (Na⁺), and Potassium (K⁺).\n• Anions: Carbonates (CO₃²⁻), Bicarbonates (HCO₃⁻), Chlorides (Cl⁻), Sulfates (SO₄²⁻), and Nitrates (NO₃⁻).\n• Contaminants: Dissolved heavy metals like Iron (Fe), Arsenic (As), Lead (Pb), and Fluoride.\n\nTDS is typically measured in Parts Per Million (PPM) or Milligrams Per Liter (mg/L).\n\n## WHO & Bangladesh Standard TDS Chart\nTDS Level (PPM) | Rating | Health & Palatability Impact\nLess than 50 | Low Mineral | Flat/tasteless water; lacks minerals.\n50 to 150 | Excellent | Ideal range for drinking water; crisp & safe.\n150 to 300 | Good | Great drinking water quality.\n300 to 600 | Fair | Acceptable; noticeable mineral taste.\n600 to 900 | Poor | High mineral deposits; pipe scaling.\nAbove 1200 | Unacceptable | Unsafe for daily drinking; potential toxic metals.\n\n## Why High TDS Water is Dangerous in Bangladesh\nIn many districts of Bangladesh (such as Khulna, Jessore, Gazipur, and Narayanganj), tube-well water frequently records TDS levels between 600 and 1,800 PPM due to salinity intrusion, industrial runoff, and high iron content.\n\n• Health Risks: Prolonged consumption of high-TDS water containing heavy metals increases the risk of kidney stones, hypertension, gastrointestinal disorders, and heavy metal toxicity.\n• Appliance Damage: High TDS water causes heavy limescale deposits inside electric kettles, water heaters, and pipe fittings.\n\n> "A common myth is that 0 TDS water is healthiest. In reality, ideal drinking water should have balanced TDS between 80 and 150 PPM, enriched with essential calcium and magnesium."\n\n## How Aqua Point Solves TDS Imbalance\nAqua Point Reverse Osmosis systems utilize an adjustable Mineral TDS Controller. The RO membrane first strips out heavy metals and excess salts down to ~20 PPM, and the Mineralizer stage enriches the purified water back to a healthy, delicious 80–120 PPM range.\n\nTest your home water TDS for free today by requesting an Aqua Point technician visit!',
        ),
      ];
    }

    if (widget.initialIndex >= 0 && widget.initialIndex < _blogs.length) {
      _currentPage = widget.initialIndex;
    } else {
      _currentPage = 0;
    }

    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showContactOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        const textColor = AppColors.textPrimary;
        const secTextColor = AppColors.textSecondary;
        const cardBg = AppColors.background;
        const borderCol = AppColors.border;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
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
                  side: const BorderSide(color: borderCol),
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
                  side: const BorderSide(color: borderCol),
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
                subtitle: Text('Instant chat assistance', style: GoogleFonts.inter(fontSize: 12, color: secTextColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening WhatsApp Chat (+8801780885841) 💬', style: GoogleFonts.inter()),
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

  Future<void> _openUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch $urlString', style: GoogleFonts.inter()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link', style: GoogleFonts.inter()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildArticleSlide(BlogEntity blog) {
    const textColor = AppColors.textPrimary;
    const textSecColor = AppColors.textSecondary;
    const borderCol = AppColors.border;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Cover Image
          _buildFeaturedCoverImage(blog.imageUrl),
          const Gap(20),

          // Category Badge & Read Time
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
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
          const Gap(14),

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
                blog.author ?? 'Enjamamul Haque (Kiron)',
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
          const Divider(height: 1),
          const Gap(20),

          // Rich Formatted Article Content
          _buildFormattedBlogContent(blog.content ?? ''),

          const Gap(32),
          const Divider(height: 1),
          const Gap(24),

          // Bottom Expert CTA Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
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
                      _showContactOptionsModal(context);
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
                      'Ask a Water Purification Specialist',
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

          const Gap(20),

          // Share Article Action
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
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

          const Gap(40),
        ],
      ),
    );
  }

  Widget _buildFeaturedCoverImage(String imageUrl) {
    const bgCol = AppColors.surfaceVariant;
    const secTextColor = AppColors.textSecondary;

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: imageUrl.startsWith('assets/')
            ? Image.asset(
                imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: bgCol,
                  alignment: Alignment.center,
                  child: const Icon(Icons.water_drop_rounded, size: 48, color: AppColors.primary),
                ),
              )
            : Image.network(
                imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  final fallbackAsset = imageUrl.contains('blog_boiled')
                      ? 'assets/images/blog_boiled_water.png'
                      : imageUrl.contains('blog_ceo')
                          ? 'assets/images/blog_ceo_desk.png'
                          : imageUrl.contains('blog_plant')
                              ? 'assets/images/blog_plant_system.jpg'
                              : 'assets/images/blog_ro_header.png';
                  return Image.asset(
                    fallbackAsset,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: bgCol,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop_rounded, size: 48, color: AppColors.primary),
                          Gap(8),
                          Text('Aqua Point Purification Guide', style: TextStyle(color: secTextColor, fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildFormattedBlogContent(String content) {
    const textColor = AppColors.textPrimary;
    const secTextColor = AppColors.textSecondary;
    const borderCol = AppColors.border;

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

      // Inline Image Check: ![alt](path_or_url)
      final imageMatch = RegExp(r'!\[(.*?)\]\((.*?)\)').firstMatch(trimmed);
      if (imageMatch != null) {
        final altText = imageMatch.group(1) ?? '';
        final imagePath = imageMatch.group(2) ?? '';

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderCol, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imagePath.startsWith('assets/')
                        ? Image.asset(
                            imagePath,
                            height: 220,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 180,
                              color: AppColors.surfaceVariant,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported_rounded, color: secTextColor),
                            ),
                          )
                        : Image.network(
                            imagePath,
                            height: 220,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              final fallbackAsset = imagePath.contains('blog_ro_diagram')
                                  ? 'assets/images/blog_ro_diagram.png'
                                  : imagePath.contains('blog_uv_diagram')
                                      ? 'assets/images/blog_uv_diagram.png'
                                      : imagePath.contains('blog_uf_diagram')
                                          ? 'assets/images/blog_uf_diagram.jpg'
                                          : imagePath.contains('blog_boiled')
                                              ? 'assets/images/blog_boiled_water.png'
                                              : imagePath.contains('blog_ceo')
                                                  ? 'assets/images/blog_ceo_desk.png'
                                                  : imagePath.contains('blog_plant')
                                                      ? 'assets/images/blog_plant_system.jpg'
                                                      : 'assets/images/blog_ro_header.png';
                              return Image.asset(
                                fallbackAsset,
                                height: 220,
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => Container(
                                  height: 180,
                                  color: AppColors.surfaceVariant,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported_rounded, color: secTextColor),
                                ),
                              );
                            },
                          ),
                    if (altText.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        color: AppColors.surfaceVariant,
                        child: Text(
                          altText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: secTextColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }

      // Social Connect Links Block Parser
      if (trimmed.contains('• Facebook:') ||
          trimmed.contains('• Instagram:') ||
          trimmed.contains('• LinkedIn:') ||
          trimmed.contains('• Website:')) {
        final lines = trimmed.split('\n');
        final List<Widget> socialButtons = [];

        for (final line in lines) {
          final l = line.trim();
          String? platform;
          String? url;
          IconData icon = Icons.link_rounded;
          Color btnColor = AppColors.primary;

          if (l.contains('Facebook:')) {
            platform = 'Facebook';
            url = l.substring(l.indexOf('Facebook:') + 9).trim();
            icon = Icons.facebook;
            btnColor = const Color(0xFF1877F2);
          } else if (l.contains('Instagram:')) {
            platform = 'Instagram';
            url = l.substring(l.indexOf('Instagram:') + 10).trim();
            icon = Icons.camera_alt_rounded;
            btnColor = const Color(0xFFE4405F);
          } else if (l.contains('LinkedIn:')) {
            platform = 'LinkedIn';
            url = l.substring(l.indexOf('LinkedIn:') + 9).trim();
            icon = Icons.business_center_rounded;
            btnColor = const Color(0xFF0A66C2);
          } else if (l.contains('Website:')) {
            platform = 'Website';
            url = l.substring(l.indexOf('Website:') + 8).trim();
            icon = Icons.language_rounded;
            btnColor = AppColors.primary;
          }

          if (platform != null && url != null && url.isNotEmpty) {
            final finalUrl = url;
            socialButtons.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openUrl(finalUrl),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: btnColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: btnColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: btnColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: Colors.white, size: 18),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  platform,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  finalUrl,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: secTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, color: btnColor, size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }

        if (socialButtons.isNotEmpty) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: socialButtons,
              ),
            ),
          );
          continue;
        }
      }

      // Headers: # / ## / ###
      if (trimmed.startsWith('### ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 8),
            child: Text(
              trimmed.substring(4),
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
        continue;
      } else if (trimmed.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trimmed.substring(3),
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(4),
                Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      } else if (trimmed.startsWith('# ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 12),
            child: Text(
              trimmed.substring(2),
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
        continue;
      }

      // Markdown Tables (| Header | Header |)
      if (trimmed.contains('|') && trimmed.contains('\n')) {
        final tableLines = trimmed.split('\n').where((l) => l.trim().startsWith('|')).toList();
        if (tableLines.length >= 2) {
          final cleanRows = <List<String>>[];
          for (final line in tableLines) {
            if (line.contains('---') || line.contains(':-')) continue;
            final cells = line.split('|').map((c) => c.trim()).where((c) => c.isNotEmpty).toList();
            if (cells.isNotEmpty) {
              cleanRows.add(cells);
            }
          }

          if (cleanRows.isNotEmpty) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderCol),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      border: TableBorder.all(
                        color: borderCol,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      children: cleanRows.asMap().entries.map((entry) {
                        final rowIndex = entry.key;
                        final row = entry.value;
                        final isHeader = rowIndex == 0;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: isHeader
                                ? AppColors.primaryLight
                                : (rowIndex % 2 == 1
                                    ? AppColors.surfaceVariant.withValues(alpha: 0.5)
                                    : Colors.transparent),
                          ),
                          children: row.map((cell) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              child: Text(
                                cell,
                                style: GoogleFonts.inter(
                                  fontSize: isHeader ? 13 : 12.5,
                                  fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                                  color: isHeader
                                      ? AppColors.primary
                                      : textColor,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
            continue;
          }
        }
      }

      // Bullet Lists (- item or * item)
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        final items = trimmed.split('\n');
        for (final item in items) {
          final cleanItem = item.replaceFirst(RegExp(r'^[-*]\s+'), '').trim();
          if (cleanItem.isEmpty) continue;
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7, right: 10),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      cleanItem,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        continue;
      }

      // Numbered List
      if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) {
        final items = trimmed.split('\n');
        for (final item in items) {
          final match = RegExp(r'^(\d+)\.\s+(.*)').firstMatch(item.trim());
          if (match == null) continue;
          final num = match.group(1);
          final text = match.group(2) ?? '';
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      num ?? '1',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        continue;
      }

      // Standard Paragraph
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            trimmed,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: textColor,
              height: 1.6,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildBottomNavigationBar() {
    const surfaceColor = AppColors.surface;
    const textColor = AppColors.textPrimary;
    const borderColor = AppColors.border;
    final isFirstSlide = _currentPage == 0;
    final isLastSlide = _currentPage == _blogs.length - 1;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            IconButton.filledTonal(
              onPressed: isFirstSlide
                  ? null
                  : () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
                disabledBackgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
              ),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: isFirstSlide
                    ? AppColors.textTertiary
                    : textColor,
              ),
            ),

            // Slide Dots / Indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_blogs.length, (index) {
                final isSelected = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isSelected ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textTertiary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            // Next Button
            IconButton.filledTonal(
              onPressed: isLastSlide
                  ? null
                  : () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
                disabledBackgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
              ),
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: isLastSlide
                    ? AppColors.textTertiary
                    : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.background;
    const surfaceColor = AppColors.surface;
    const textColor = AppColors.textPrimary;
    const secTextColor = AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textColor,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Water Knowledge & Guides',
          style: GoogleFonts.outfit(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          if (_blogs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Article ${_currentPage + 1} of ${_blogs.length}',
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _blogs.isEmpty
          ? Center(
              child: Text(
                'No articles available.',
                style: GoogleFonts.inter(color: secTextColor),
              ),
            )
          : PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: _blogs.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final blog = _blogs[index];
                return _buildArticleSlide(blog);
              },
            ),
      bottomNavigationBar: _blogs.isNotEmpty ? _buildBottomNavigationBar() : null,
    );
  }
}
