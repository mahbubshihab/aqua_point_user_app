import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/core/services/firebase_service.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/category_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';
import '../models/banner_model.dart';
import '../models/company_info_model.dart';

class HomeRemoteDatasource {
  final FirebaseFirestore _firestore;

  HomeRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService.firestore;

  Future<List<ProductEntity>> fetchProductsByType(String type, {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('type', isEqualTo: type)
          .limit(limit)
          .get();

      return snapshot.docs.map((docSnap) => ProductModel.fromFirestore(docSnap)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    try {
      QuerySnapshot snapshot;
      try {
        snapshot = await _firestore
            .collection('banners')
            .where('isActive', isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .limit(15)
            .get();
      } catch (_) {
        snapshot = await _firestore
            .collection('banners')
            .where('isActive', isEqualTo: true)
            .limit(15)
            .get();
      }

      final List<BannerModel> banners = [];
      for (final doc in snapshot.docs) {
        final model = BannerModel.fromFirestore(doc);
        if (model.imageUrl.isNotEmpty) {
          banners.add(model);
        }
      }
      return banners;
    } catch (e) {
      rethrow;
    }
  }

  Future<CompanyInfoModel> fetchCompanyInfo() async {
    try {
      final doc = await _firestore.collection('company_info').doc('main').get();
      if (doc.exists) {
        return CompanyInfoModel.fromFirestore(doc);
      }
      return const CompanyInfoModel();
    } catch (_) {
      return const CompanyInfoModel();
    }
  }

  Future<HydrationEntity> fetchHydrationData() async {
    return const HydrationEntity(
      currentGlasses: 0,
      targetGlasses: 8,
    );
  }

  Future<WaterQualityEntity> fetchWaterQualityData() async {
    return const WaterQualityEntity(
      tds: 18,
      status: 'Excellent',
      iron: 0.01,
      ph: 7.2,
      hardness: 'Soft',
    );
  }

  Future<List<BlogEntity>> fetchBlogs() async {
    try {
      final snapshot = await _firestore.collection('blogs').get();
      if (snapshot.docs.isNotEmpty) {
        final List<BlogEntity> blogs = [];
        for (final doc in snapshot.docs) {
          final data = doc.data();
          blogs.add(BlogEntity(
            id: doc.id,
            title: data['title'] ?? '',
            date: data['date'] ?? '',
            imageUrl: data['imageUrl'] ?? data['image'] ?? '',
            category: data['category'],
            readTime: data['readTime'],
            content: data['content'],
          ));
        }
        return blogs;
      }
    } catch (_) {}

    return const [
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

  Future<List<CategoryEntity>> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();

      if (snapshot.docs.isNotEmpty) {
        final List<CategoryEntity> categories = [];
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final name = data['name'] ?? data['title'] ?? 'Category';
          final icon = data['icon'];
          final imageUrl = data['imageUrl'] ?? data['image'] ?? data['photoUrl'];
          final count = (data['productCount'] as num?)?.toInt() ?? 0;
          categories.add(CategoryEntity(
            id: doc.id,
            name: name,
            icon: icon,
            imageUrl: imageUrl,
            productCount: count,
          ));
        }
        return categories;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

}

