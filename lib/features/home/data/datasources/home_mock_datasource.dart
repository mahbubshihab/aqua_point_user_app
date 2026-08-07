import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';

class HomeMockDatasource {
  Future<HydrationEntity> fetchHydrationData() async {
    return const HydrationEntity(
      currentGlasses: 0,
      targetGlasses: 8,
    );
  }

  Future<WaterQualityEntity> fetchWaterQualityData() async {
    return const WaterQualityEntity(
      tds: 120,
      status: 'EXCELLENT',
      iron: 0.05,
      ph: 7.2,
      hardness: 'Low Soft',
    );
  }

  Future<List<BlogEntity>> fetchBlogs() async {
    return const [
      BlogEntity(
        id: '1',
        title: 'ওয়াটার ট্রিটমেন্ট ও নিরাপদ পানির গুরুত্ব - পর্ব ২৪',
        date: 'Jan 30, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e',
      ),
      BlogEntity(
        id: '2',
        title: 'বাসায় পানির TDS লেভেল কীভাবে পরীক্ষা করবেন',
        date: 'Jan 25, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d',
      ),
      BlogEntity(
        id: '3',
        title: 'বিশুদ্ধ খাবার পানির স্বাস্থ্য উপকারিতা',
        date: 'Jan 20, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      ),
    ];
  }
}
