import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../tools/presentation/pages/blogs_news_page.dart';
import '../../domain/entities/blog_entity.dart';

class HomeBlogSwiperSection extends StatefulWidget {
  final List<BlogEntity>? blogs;
  final VoidCallback? onViewAllTap;
  final ValueChanged<int>? onBlogTap;

  const HomeBlogSwiperSection({
    super.key,
    this.blogs,
    this.onViewAllTap,
    this.onBlogTap,
  });

  @override
  State<HomeBlogSwiperSection> createState() => _HomeBlogSwiperSectionState();
}

class _HomeBlogSwiperSectionState extends State<HomeBlogSwiperSection> {
  late final PageController _pageController;
  late List<BlogEntity> _blogList;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  static const List<BlogEntity> _defaultBlogs = [
    BlogEntity(
      id: 'blog-1',
      title: 'Enjamamul Haque (Kiron) – Founder & CEO, Aqua Point BD',
      date: 'July 25, 2026',
      imageUrl:
          'https://aquapointbd.com/wp-content/uploads/2026/07/Picsart_25-11-23_21-43-06-399.jpg.webp',
      category: 'Leadership & Vision',
      readTime: '5 min read',
    ),
    BlogEntity(
      id: 'blog-2',
      title: 'রিভার্স অসমোসিস (RO) সিস্টেম কীভাবে কাজ করে?',
      date: 'July 22, 2026',
      imageUrl:
          'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-22-at-1.32.53-PM.webp',
      category: 'Tech & Innovation',
      readTime: '4 min read',
    ),
    BlogEntity(
      id: 'blog-3',
      title: 'RO, UV, UF How to Choose the Right Water Purifier for Your Home',
      date: 'July 23, 2026',
      imageUrl:
          'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-22-at-12.00.01-PM.webp',
      category: 'Purifier Guide',
      readTime: '6 min read',
    ),
    BlogEntity(
      id: 'blog-4',
      title: 'Enjamamul Haque (Kiron) – Founder & CEO, Aqua Point BD',
      date: 'July 22, 2026',
      imageUrl:
          'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-22-at-2.47.00-PM.webp',
      category: 'CEO Journey',
      readTime: '5 min read',
    ),
    BlogEntity(
      id: 'blog-5',
      title: 'Boiled Water vs. Purified Water',
      date: 'July 22, 2026',
      imageUrl:
          'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-22-at-12.40.56-PM.webp',
      category: 'Health & Wellness',
      readTime: '5 min read',
    ),
    BlogEntity(
      id: 'blog-6',
      title: 'What is Required to Set Up a Commercial Battery Water Plant?',
      date: 'July 23, 2026',
      imageUrl:
          'https://aquapointbd.com/wp-content/uploads/2026/07/WhatsApp-Image-2026-07-23-at-10.18.32-AM.webp',
      category: 'Commercial Guide',
      readTime: '7 min read',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.blogs != null && widget.blogs!.isNotEmpty) {
      _blogList = widget.blogs!;
    } else {
      _blogList = _defaultBlogs;
    }

    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant HomeBlogSwiperSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blogs != oldWidget.blogs) {
      setState(() {
        if (widget.blogs != null && widget.blogs!.isNotEmpty) {
          _blogList = widget.blogs!;
        } else {
          _blogList = _defaultBlogs;
        }
        if (_currentIndex >= _blogList.length) {
          _currentIndex = 0;
        }
      });
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (!mounted || _blogList.isEmpty) return;
      final nextIndex = (_currentIndex + 1) % _blogList.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onBlogSelected(int index) {
    if (widget.onBlogTap != null) {
      widget.onBlogTap!(index);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlogsNewsPage(
            initialBlogs: _blogList,
            initialIndex: index,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FROM OUR BLOGS',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF005C97),
                  letterSpacing: 1.0,
                ),
              ),
              GestureDetector(
                onTap: widget.onViewAllTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlogsNewsPage(
                            initialBlogs: _blogList,
                          ),
                        ),
                      );
                    },
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00B4DB),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Swiper Container (1 card visible at a time)
        SizedBox(
          height: 275,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: _blogList.length,
            itemBuilder: (context, index) {
              final blog = _blogList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: _BlogCard(
                  blog: blog,
                  onTap: () => _onBlogSelected(index),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_blogList.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 14 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isActive ? 4 : 3),
                color: isActive
                    ? const Color(0xFF005C97)
                    : const Color(0xFF00B4DB).withValues(alpha: 0.40),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BlogCard extends StatefulWidget {
  final BlogEntity blog;
  final VoidCallback onTap;

  const _BlogCard({
    required this.blog,
    required this.onTap,
  });

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Cover Image (170px)
          Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A0077B6),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Network image with graceful fallbacks
                  _buildCoverImage(widget.blog.imageUrl),

                  // Bottom dark blue gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x4D023E8A),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Overlapped White Card (Centered text + Read More pill)
          Positioned(
            top: 130,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  bottom: BorderSide(
                    color: _isHovered
                        ? const Color(0xFF00B4DB)
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1400B4D8),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.blog.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // READ MORE -> Pill Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x330077B6),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'READ MORE',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: const Color(0xFFE2E8F0),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Color(0xFF00B4DB),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    } else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF005C97), Color(0xFF00B4DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.water_drop_rounded,
          color: Colors.white70,
          size: 40,
        ),
      ),
    );
  }
}
