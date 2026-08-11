import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../home/domain/entities/blog_entity.dart';

class BlogsNewsPage extends StatefulWidget {
  final List<BlogEntity>? initialBlogs;

  const BlogsNewsPage({
    super.key,
    this.initialBlogs,
  });

  @override
  State<BlogsNewsPage> createState() => _BlogsNewsPageState();
}

class _BlogsNewsPageState extends State<BlogsNewsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Health Tips',
    'RO Maintenance',
    'TDS Guide',
    'Aqua Updates',
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
          id: 'b1',
          title: 'Why 8 Glasses of Pure Water Daily Boosts Immunity & Health',
          date: '05 Aug 2026',
          imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?w=800',
          category: 'Health Tips',
          readTime: '3 min read',
          content: 'Proper hydration is essential for regulating body temperature, keeping joints lubricated, preventing infections, delivering nutrients to cells, and keeping organs functioning properly. Drinking purified RO water eliminates micro-contaminants and ensures your immune system stays strong.',
        ),
        BlogEntity(
          id: 'b2',
          title: 'When & How to Replace Your RO Water Purifier Membrane',
          date: '01 Aug 2026',
          imageUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800',
          category: 'RO Maintenance',
          readTime: '5 min read',
          content: 'The Reverse Osmosis (RO) membrane is the heart of your water purifier. Typically, RO membranes need replacement every 12 to 24 months depending on input water TDS. Indicators that your membrane needs replacement include a drop in flow rate, changes in taste, or rising TDS output.',
        ),
        BlogEntity(
          id: 'b3',
          title: 'Understanding TDS Meters: What Numbers Mean for Drinking Water',
          date: '28 Jul 2026',
          imageUrl: 'https://images.unsplash.com/photo-1527100673774-cce25eafaf7f?w=800',
          category: 'TDS Guide',
          readTime: '4 min read',
          content: 'TDS stands for Total Dissolved Solids and represents the total concentration of dissolved substances in water. According to WHO standards, drinking water with TDS less than 300 PPM is considered excellent. Learn how to calibrate your TDS meter and read results accurately.',
        ),
        BlogEntity(
          id: 'b4',
          title: 'Aqua Point Introduces Next-Gen AI Smart Leak Detection',
          date: '20 Jul 2026',
          imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800',
          category: 'Aqua Updates',
          readTime: '2 min read',
          content: 'Aqua Point is excited to announce our new AI-powered Smart Leak Detection system integrated into our flagship RO machines. The system monitors pressure variations in real-time and alerts your smartphone instantly if micro-leaks are detected.',
        ),
        BlogEntity(
          id: 'b5',
          title: 'Top 5 Signs Your Sediment Filter Is Clogged',
          date: '12 Jul 2026',
          imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
          category: 'RO Maintenance',
          readTime: '4 min read',
          content: 'Sediment pre-filters catch sand, rust, and dirt before water enters the RO membrane. Common signs of clogging include reduced water pressure, unusual noises from the booster pump, and cloudy output water.',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBlogDetail(BlogEntity blog) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          blog.category ?? 'Article',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                      const Gap(4),
                      Text(
                        blog.readTime ?? '3 min read',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Published on ${blog.date} • Aqua Point Water Care Team',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const Gap(16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      blog.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: AppColors.inputFill,
                        child: const Center(
                          child: Icon(Icons.article_rounded, size: 48, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Text(
                    blog.content ??
                        'Water purification is vital for clean, disease-free living. Aqua Point systems utilize multi-stage filtration ensuring every drop of water you drink meets international health standards.',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  const Gap(24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Article link shared successfully! 📲'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                      label: const Text('Share Article', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBlogs = _allBlogs.where((blog) {
      final matchesQuery = blog.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || (blog.category == _selectedCategory);
      return matchesQuery && matchesCategory;
    }).toList();

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
          'Water Health Blogs & News',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Field Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search blogs, guides & water tips...',
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Horizontal Category Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    backgroundColor: AppColors.inputFill,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.cardBorder,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(8),

          // Blogs List View
          Expanded(
            child: filteredBlogs.isEmpty
                ? const Center(
                    child: Text(
                      'No articles found matching your criteria.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = filteredBlogs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GlassCard(
                          padding: const EdgeInsets.all(14),
                          borderRadius: 18,
                          onTap: () => _openBlogDetail(blog),
                          borderColor: AppColors.primary.withValues(alpha: 0.2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Blog Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  color: AppColors.inputFill,
                                  child: Image.network(
                                    blog.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Center(
                                      child: Icon(Icons.article_rounded, color: AppColors.primary, size: 28),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(14),

                              // Blog Text Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          blog.category ?? 'Health',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          blog.date,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(6),
                                    Text(
                                      blog.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const Gap(8),
                                    Row(
                                      children: [
                                        const Icon(Icons.menu_book_rounded, size: 12, color: AppColors.textSecondary),
                                        const Gap(4),
                                        Text(
                                          blog.readTime ?? '3 min read',
                                          style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          'Read More >',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
