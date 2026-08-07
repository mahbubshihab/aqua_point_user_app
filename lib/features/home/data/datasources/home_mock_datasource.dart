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
        title: 'Importance of Pure Water & Treatment - Part 24',
        date: 'Jan 30, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e',
      ),
      BlogEntity(
        id: '2',
        title: 'How to Check TDS Levels of Drinking Water at Home',
        date: 'Jan 25, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d',
      ),
      BlogEntity(
        id: '3',
        title: 'Health Benefits of Drinking Pure Filtered Water',
        date: 'Jan 20, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      ),
      BlogEntity(
        id: '4',
        title: 'Advanced Filtration Technology - Part 60',
        date: 'Jan 15, 2026',
        imageUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b',
      ),
    ];
  }
}
